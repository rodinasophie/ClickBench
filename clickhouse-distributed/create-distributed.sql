CREATE TABLE hits_all
ENGINE = Distributed('{cluster}', default, hits, rand())
SETTINGS
    fsync_after_insert=0,
    fsync_directories=0;