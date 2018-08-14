#!/bin/bash

# use path to emsdk folder, relative to this directory
if [[ :$PATH: != *:"/emsdk":* ]]
then
  BASEDIR="./../emsdk"
  BASEDIRSHA="./../../../Documents/emsdk"
  EMSDK_ENV=$(find "$BASEDIR" -type f -name "emsdk_env.sh")
  source "$EMSDK_ENV"
fi
# add exported C/C++ functions here
CPP_FUNCS="[
 '_grayScale',
 '_brighten',
 '_invert',
 '_noise',
 '_multiFilter',
 '_sobelFilter',
 '_convFilter',
 '_malloc',
 '_free',
 '_main'
]" 

emcc -o ./webdsp_c.js ./main.cpp -lm -O3 -s WASM=1 \
-s BINARYEN_IMPRECISE=1 \
-s EXPORTED_FUNCTIONS="$CPP_FUNCS" \
-s ALLOW_MEMORY_GROWTH=1 \

cp ./webdsp_c.js ../../public/
cp ./webdsp_c.wasm ../../public/

sed -i .bak 's/else{doRun()}/&script.dispatchEvent(doneEvent);/' lib/webdsp_c.js

rm lib/*.bak