CREATE TABLE hits_all_replicated AS hits
ENGINE = Distributed('{cluster}', default, hits_replicated)
SETTINGS
    fsync_after_insert=0,
    fsync_directories=0;