#!/bin/bash
. ../log.sh;

log info 'LOAD [START]';

DDL_FILE_QUEUE=files.ddls.txt
DATA_FILE_QUEUE=files.data.txt
# survey files provided as input
ls -H input/ | grep '.ddl' | grep '.sql' > $DDL_FILE_QUEUE;
ls -H input/ | grep '.sql.gz' > $DATA_FILE_QUEUE;

PGOPTIONS="--search_path=public"
export PGOPTIONS

while read FILENAME; do
    log info "LOAD [PROCESSING]: DDL_FILE_QUEUE-${FILENAME}";

    psql \
        -h $DB_HOST \
        -p $DB_PORT \
        -d $DB_NAME \
        -U $DB_USERNAME \
        -f input/$FILENAME \
        1>> $ETL_LOG_STDOUT 2>> $ETL_LOG_STDERR;

done <$DDL_FILE_QUEUE

while read FILENAME; do
    log info "LOAD [PROCESSING]: DATA_FILE_QUEUE-${FILENAME}";

    gunzip -c input/$FILENAME | psql \
        -h $DB_HOST \
        -p $DB_PORT \
        -d $DB_NAME \
        -U $DB_USERNAME
        1>> $ETL_LOG_STDOUT 2>> $ETL_LOG_STDERR;
        
done <$DATA_FILE_QUEUE


publish_json_logs;
log info 'LOAD [COMPLETE]';
