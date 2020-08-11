#!/bin/bash

DIR=$1

for f in "$DIR"/*/*/*; do
  if [ -d "$f" ]; then
    for file in "$f"/*.wav; do
      (
      sourcefile=$file
      filename="${file%.*}"
      destfile="$filename.gsm"

      echo $sourcefile;
      ffmpeg -loglevel panic -y -i $sourcefile -c:a libgsm -vn -ar 8000 -ac 1 -ab 13000 -f gsm $destfile
      ffmpeg -loglevel panic -y -i $destfile -loglevel error -v quiet -acodec pcm_s16le -ar 8000 -ac 1 $sourcefile
      rm $destfile
      ) &
    done
    wait
  fi
done


