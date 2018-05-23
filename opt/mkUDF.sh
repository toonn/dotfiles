#! /usr/bin/env sh
# Source: http://duncanlock.net/blog/2013/05/13/
#           using-udf-as-an-improved-filesystem-for-usb-flash-drives
# References:
# - http://tanguy.ortolo.eu/blog/article93/usb-udf
# - https://bbs.archlinux.org/viewtopic.php?pid=1030147
# Identifiers: https://superuser.com/questions/366808/
#                in-udf-whats-the-difference-between-a-volume-identifier
#                -volume-set-identifier
#              Equivalent Share Link: https://superuser.com/a/901751

if [ $1 = '-h' -o $1 = '--help' ]
then
  echo ""
  echo "  mkUDF.sh <device> <name>"
  echo "    # Where <device> is a block device, e.g. /dev/sdx"
  echo "    # and <name> is a string, e.g. MyDisk"
elif [ $# -ne 2 ]
then
  echo ""
  echo "  mkUDF.sh needs exactly two arguments, the <device> and a <name>."
elif [ ! -b $1 ]
then
  echo ""
  echo "  The first argument needs to be a valid block <device>, e.g. /dev/sdx."
else
  dd if=/dev/zero of=$1 bs=1M count=1
  mkudffs -b 512 --media-type=hd --utf8 --lvid=$2 $1
fi
