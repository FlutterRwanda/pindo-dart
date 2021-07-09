#!/bin/bash
cd "example"
FLUTTER_BRANCH=`grep channel: .metadata | sed 's/  channel: //g'`

# Get flutter
git clone https://github.com/flutter/flutter.git
FLUTTER=flutter/bin/flutter

cmd="${FLUTTER} channel ${FLUTTER_BRANCH}"

DIR=$($cmd >& /dev/stdout)
echo "<!-- $DIR -->"
$FLUTTER config --enable-web
if [[ $DIR == *"Your branch is behind"* ]]; then
  echo "Update starting"
  $FLUTTER upgrade
  echo "Update finished"
fi

$FLUTTER build web --release