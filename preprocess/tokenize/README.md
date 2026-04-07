hq server start

hq alloc add slurm --time-limit 30m \
  --max-worker-count 2 \
  --cpus 32 \
  -- \
  --account=project_462000963 \  
  --partition=debug \
  --mem=40G

hq submit \
  --nodes 1 \
  --cpus 32 \
  --each-line   
  ./hq-tokenize.sh


hq alloc add slurm \
  --time-limit 5h \
  --max-worker-count 30 \
  --cpus 32 \
  -- \
  --account=project_462000963 \
  --partition=small \
  --mem=40G

hq submit --cpus 32 --time-request 00:20:00 --each-line files-head.txt  ./hq-tokenize.sh


hq submit --cpus 32 --each-line the-stack-1.2.txt ./uncompress-tokenize.sh
hq submit --cpus 32 --each-line=the-stack-1.2.txt --array=`hq job task-ids last --filter=failed` ./uncompress-tokenize.sh
hq submit --cpus 32 --each-line=the-stack-1.2.txt --array=`hq job task-ids 12 --filter=failed` ./uncompress-tokenize.sh
