CUDA_VISIBLE_DEVICES=0,1 python3 train.py --lang ru \
  --model Wav2LetterRu \
  --checkpoint data/checkpoints_w2l/checkpoint_epoch00_iter0049654.pt \
  --val-batch-size 40 --val-data-path ../sample_ok/sample_ok.convasr.csv 

#  --val-batch-size 40 --val-data-path  ../open_stt_splits/splits/clean_val.csv ../open_stt_splits/splits/mixed_val.csv ../sample_ok/sample_ok.convasr.csv \
#  --checkpoint model_checkpoint_0027_epoch_02.model.pt \
