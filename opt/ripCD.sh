#! /usr/bin/env sh
# Requirements: cdda2wav from cdrtools/cdrkit, ffmpeg for encoding of aac,
#               flac, mp3 and opus
#
# ffmpeg needs to be compiled with --enable-libmp3lame for mp3 support,
# --enable-libopus for opus support, and --enable-libfdk-aac for Fraunhofer aac
# support. The Fraunhofer FDK AAC library is recommended as the highest quality
# aac encoder on the ffmpeg wiki. https://trac.ffmpeg.org/wiki/Encode/AAC

err() {
  echo >&2 "$1"
}

has() {
  command -v "$1" >/dev/null 2>&1 \
    || { echo >&2 "I require $1 but it's not installed. Aborting."
         exit 1
       }
}

while [ $# -gt 0 ]
do case $1 in
     -h|--help)
       echo ""
       echo "  ripCD.sh [-t|--dest=<dest>] [-d|--dev=<dev>]"
       echo "           [-e|--encoding=<encoding>]"
       echo "    # Where <dev> is your optical drive, if omitted cdda2wav will"
       echo "    # attempt to detect it. <dest> is an optional directory to"
       echo "    # write to, defaults to \"cdrom\". Optional argument"
       echo "    # <encoding> specifies the format to encode to, one of"
       echo "    # aac, flac, mp3, opus and wav, defaults to wav."
       exit
       ;;
     -d)
       DEV="$2"
       shift; shift
       ;;
     --dev=*)
       DEV="${1#*=}"
       shift
       ;;
     -e)
       ENC="$2"
       shift; shift
       ;;
     --encoding=*)
       ENC="${1#*=}"
       shift
       ;;
     -t)
       DEST="$2"
       shift; shift
       ;;
     --dest=*)
       DEST="${1#*=}"
       shift
       ;;
     *)
       if [ -z "$DEV" ] && [ -d "$1" ]
       then
         DEV="$1"
       else
         err "Error: Unexpected argument! \"$1\""
       fi
       shift
       ;;
   esac
done

DEST=${DEST:-./cdrom}
ENC=${ENC:-wav}
case $ENC in
  aac|flac|mp3|opus|wav)
    ;;
  *)
    echo ""
    err "Unknown encoding \"$ENC\""
    exit
    ;;
esac
tmpname=$(basename "$0")-XXXXXX

has 'cdda2wav'
has 'ffmpeg'

echo ""
if [ ! -d "$DEST" ]
then
  echo "Creating \"$DEST\"..."
  mkdir -p "$DEST"
else
  echo "\"$DEST\" already exists, moving on..."
fi

echo ""
echo "Creating temporary directory to store wavs..."
srctmp=$(mktemp -t "$tmpname" -d)

echo ""
echo "Ripping wavs from disc this usually requires root privileges..."
workingdir="$PWD"
cd "$srctmp" || exit
platform=$(uname)
if [ "$platform" = "Darwin" ]
then
  echo "Make sure there's no disk in the tray."
  echo "We need to temporarily stop diskarbitrationd otherwise we can't"
  echo "access the disc."
  echo "Press enter to continue"
  read -r
  diskarbitrationPID=$(pgrep diskarbitrationd)
  sudo kill -STOP "$diskarbitrationPID"
  echo "Please insert the disc."
  echo "Press enter to continue"
  read -r
fi
sudo cdda2wav -vall cddb=0 speed=4 -paranoia paraopts=proof -alltracks "$DEV"
if [ "$platform" = "Darwin" ]
then
  echo "Resuming diskarbitrationd..."
  sudo kill -CONT "$diskarbitrationPID"
fi
cd "$workingdir" || exit
sudo chown -R "$USER" "$srctmp"

if [ ! "$ENC" = "wav" ]
then
  echo ""
  echo "Creating temporary directory to store ${ENC}s..."
fi
desttmp=$(mktemp -t "$tmpname" -d)
for wav in "$srctmp"/*.wav
do
  extless=${wav%.wav}
  inf="$extless".inf
  tracknr=${extless##*_}
  albumtitle=$(grep Albumtitle "$inf" | sed -E "s/.*'(.*)'$/\1/")
  albumperformer=$(grep Albumperformer "$inf" | sed -E "s/.*'(.*)'$/\1/")
  tracktitle=$(grep Tracktitle "$inf" | sed -E "s/.*'(.*)'$/\1/")
  performer=$(grep Performer "$inf" | sed -E "s/.*'(.*)'$/\1/")
  targetdir="$desttmp/$albumperformer/$albumtitle"
  target="$targetdir/$tracknr - $tracktitle - ${performer}.$ENC"
  mkdir -p "$targetdir"
  case $ENC in
    aac)
      target=${target%.aac}.m4a 
      ffmpeg -i "$wav" -c:a libfdk_aac -vbr 5 "$target" \
        || { err "No libfdk_aac support? Falling back to the native encoder" \
              && ffmpeg -i "$wav" -c:a aac -b:a 128k "$target"
           }
      ;;
    flac)
      ffmpeg -i "$wav" "$target"
      ;;
    mp3)
      ffmpeg -i "$wav" -codec:a libmp3lame -qscale:a 2 "$target" \
        || err "I need an ffmpeg compiled with libmp3lame"
      ;;
    opus)
      ffmpeg -i "$wav" -c:a libopus -vbr on -b:a 64k "$target" \
        || err "I need an ffmpeg compiled with libopus"
      ;;
    wav)
      mv "$wav" "$target"
      ;;
  esac
done

echo ""
if [ "$ENC" = opus ]
then
  ENC="opus encode"
fi
echo "Moving ${ENC}s to \"$DEST\"..."
mv "$desttmp"/* "$DEST"

echo ""
echo "Done"
