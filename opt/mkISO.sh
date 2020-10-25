#! /usr/bin/env sh
# Source: https://ubuntuforums.org/showthread.php?t=120186
# Original source: http://web.archive.org/web/20060329122624/
#                    http://dvd.chevelless230.com/index.html
# Requirements: basename, fd, mkisofs from cdrtools/cdrkit

while [ $# -gt 0 ]
do case $1 in
     -h|--help)
       unset DIR
       break
       ;;
     -n)
       NAME="$2"
       shift; shift
       ;;
     --name=*)
       NAME="${1#*=}"
       shift
       ;;
     -v)
       VOLID="$2"
       shift; shift
       ;;
     --volume-id=*)
       VOLID="${1#*=}"
       shift
       ;;
     *)
       if [ -z "$DIR" ] && [ -d "./$DIR" ]
       then
         DIR="$1"
       else
         echo ""
         echo "  Error: Unexpected argument! \"$1\""
       fi
       shift
       ;;
   esac
done

if [ -z "$DIR" ]
then
  echo ""
  echo "  mkISO.sh [-n|--name=<name>] [-v|--volume-id=<volume-id>] <dir>"
  echo "    # Where <dir> is a directory containing VIDEO_TS/AUDIO_TS dirs"
  echo "    # and <name> is an optional string used as the iso filename,"
  echo "    # e.g. MyDisk, defaults to <dir>'s basename."
  echo "    # Optional argument <volume-id> defaults to <name>; this usually"
  echo "    # shows up when mounting the iso."
  exit
else
  nameSansIso=${NAME%.iso}
  NAME=${nameSansIso:-$(basename "$DIR")}.iso
  VOLID=${VOLID:-${NAME%.iso}}

  echo ""
  echo "  Making sure there's both a VIDEO_TS and an AUDIO_TS dir..."
  if [ ! -d "$DIR/VIDEO_TS" ]
  then
    if [ -d "$DIR/AUDIO_TS" ]
    then
      mkdir "$DIR/VIDEO_TS"
    else
      echo ""
      echo "  You need at least one of VIDEO_TS/AUDIO_TS in $DIR"
      exit
    fi
  elif [ ! -d "$DIR/AUDIO_TS" ]
  then
    mkdir "$DIR/AUDIO_TS"
  fi

  echo ""
  echo "  Setting permissions 400 for files and 500 for dirs..."
  fd -t d . "$DIR" --exec-batch chmod 500 {}
  fd -t f . "$DIR" --exec-batch chmod 400 {}

  echo ""
  echo "  Creating \"$NAME\" with volume-id:"
  echo "    \"$VOLID\"..."
  mkisofs -dvd-video -udf -volid "$VOLID" -o "$NAME" "$DIR"

  echo ""
  echo "  Done"
fi
