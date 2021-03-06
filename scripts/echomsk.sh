set -e 

export CUDA_VISIBLE_DEVICES=0

ECHOMSK=data/personalno_20000101_20191231.txt.json.gz
CHECKPOINT=data/experiments/JasperNetBig_NovoGrad_lr1e-2_wd1e-3_bs256____fp16O2/checkpoint_epoch05_iter0040000.pt
SAMPLE_RATE=8000

SAMPLE=10
DATASET=echomsk$SAMPLE
DATASET_ROOT=data/$DATASET
DATASET_AUDIO=$DATASET_ROOT/audio
DATASET_TRANSCRIBE=$DATASET_ROOT/transcribe
DATASET_SUBSET=$DATASET_ROOT/subset
DATASET_CUT=$DATASET_ROOT/cut
TRANSCRIBE='--mono --align --max-segment-duration 4.0 --html'
SUBSET='--align-boundary-words --num-speakers 1 --gap 0.1- --cer 0.1-0.4 --duration 2.0-4.0'
CUT="--dilate 0.02 --sample-rate $SAMPLE_RATE --mono"

mkdir -p $DATASET_AUDIO
python3 datasets/echomsk.py -i $ECHOMSK -o $DATASET_AUDIO --sample $SAMPLE
wget --no-clobber -i $DATASET_AUDIO/audio.txt -P $DATASET_AUDIO

python3 transcribe.py --checkpoint $CHECKPOINT -i $DATASET_AUDIO -o $DATASET_TRANSCRIBE $TRANSCRIBE

python3 tools.py subset -i $DATASET_TRANSCRIBE -o $DATASET_SUBSET.json $SUBSET

python3 tools.py cut -i $DATASET_SUBSET.json -o $DATASET_CUT $CUT

python3 vis.py audiosample -i $DATASET_CUT/$(basename $DATASET_CUT).json -o $DATASET_CUT.json.html 
