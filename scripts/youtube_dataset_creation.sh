set -e 

CUDA_DEVICE=$1
THREAD=$2

export CUDA_VISIBLE_DEVICES=$CUDA_DEVICE

YOUTUBE='https://www.youtube.com/channel/UCb9_Bhv37NXN1m8Bmrm9x9w'
CHECKPOINT=best_checkpoints/JasperNetBig_NovoGrad_lr1e-4_wd1e-3_bs1024____long-train_bs1024_step6_430k_checkpoint_epoch247_iter0446576.pt
SAMPLE_RATE=8000

SAMPLE=''
DATASET=youtube$SAMPLE
DATASET_ROOT=data/$DATASET
DATASET_AUDIO=$DATASET_ROOT/audio
DATASET_AUDIO_MASK=$DATASET_AUDIO/*/*
DATASET_TRANSCRIBE=$DATASET_ROOT/transcribe
DATASET_SUBSET=$DATASET_ROOT/subset
DATASET_CUT=$DATASET_ROOT/cut
DATASET_CUT_JSON=$DATASET_ROOT/cut/cut2.json


TRANSCRIPT_PREPROC='--split-by-parts 3 --skip-files-longer-than-hours 4 --skip-transcript-after-seconds 1800 '
TRANSCRIBE='--mono --batch-time-padding-multiple 1 --align --skip-processed --max-segment-duration 4.0 --transcribe-first-n-sec 3600'
SUBSET='--num-speakers 1 --gap 0.05- --cer 0.0-0.25 --duration 0.5-8.0'
CUT="--dilate 0.025 --sample-rate $SAMPLE_RATE --mono --strip-prefix data/ --add-sub-paths --strip"
TRAIN_TEST_SPLIT='--microval-duration-in-hours 0 --val-duration-in-hours 0 --test-duration-in-hours 0 --old-microval-path cut_microval_10h.json'

#mkdir -p $DATASET_AUDIO
#bash datasets/youtube.sh LIST "$YOUTUBE" > $DATASET_ROOT/youtube.txt
#bash datasets/youtube.sh LIST 'https://www.youtube.com/channel/UCb9_Bhv37NXN1m8Bmrm9x9w'
#head -n $SAMPLE $DATASET_ROOT/youtube.txt > $DATASET_AUDIO/audio.txt # list of links like http://youtu.be/e8bkFQD3ZhA
#bash datasets/youtube.sh RETR $DATASET_AUDIO/audio.txt $DATASET_AUDIO

python3 datasets/youtube.py -i "$DATASET_AUDIO_MASK" -o $DATASET_AUDIO.json $TRANSCRIPT_PREPROC

#python3 transcribe.py --checkpoint $CHECKPOINT -i $DATASET_AUDIO.json -o $DATASET_TRANSCRIBE $TRANSCRIBE

#python3 tools.py subset -i $DATASET_TRANSCRIBE -o $DATASET_SUBSET.json $SUBSET

#python3 tools.py cut -i $DATASET_SUBSET.json -o $DATASET_CUT $CUT

#python3 tools.py split -i $DATASET_CUT_JSON -o $DATASET_CUT $TRAIN_TEST_SPLIT

#python3 vis.py audiosample -i $DATASET_CUT/$(basename $DATASET_CUT).json -o $DATASET_CUT.json.html
