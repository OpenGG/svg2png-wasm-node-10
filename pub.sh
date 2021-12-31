#!/usr/bin/env bash

set -e

URL=`npm info svg2png-wasm dist.tarball`
NAME=svg2png-wasm-node-10
TGZ=svg2png-wasm.tgz
FOLDER=package/dist

curl -L $URL -o $TGZ

tar -zxvf $TGZ

JS_FILES=(index.cjs index.min.js index.mjs)
CJS="$FOLDER/index.cjs"
HEAD="$CJS.head"

echo "const { TextEncoder, TextDecoder } = require('util')" > $HEAD
cat $CJS >> $HEAD
mv $HEAD $CJS

for js in $JS_FILES
do
    npm_config_yes=true npx esbuild "$FOLDER/$js" --target=node10 --outfile="$FOLDER/$js" --allow-overwrite
done

cd package/

cp ../README.md README.md

npm_config_yes=true npx npe name $NAME
npm_config_yes=true npx npe scripts --delete

npm publish

cd -
