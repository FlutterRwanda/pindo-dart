#!/bin/bash
## A Script to download and run flutter in Netlify.
## Not related to the package; just used for deploying the example on Netlify.
cd "example"
FLUTTER_BRANCH=`grep channel: .metadata | sed 's/  channel: //g'`

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