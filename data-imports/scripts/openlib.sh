#!/bin/bash

set -Eeuxo pipefail

# Run this script by running: docker exec -it aa-data-import--mariadb /scripts/openlib.sh
# Feel free to comment out steps in order to retry failed parts of this script, when necessary.
# This script is in principle idempotent, but it might redo a bunch of expensive work if you simply rerun it.

cd /temp-dir

aria2c -c -x16 -s16 -j16 -o ol_dump_latest.txt.gz 'https://openlibrary.org/data/ol_dump_latest.txt.gz' # Explicitly adding -o since they redirect to a different filename.

pv ol_dump_latest.txt.gz | zcat | sed -e 's/\\u0000//g' | mariadb -u root -ppassword allthethings --local-infile=1 --show-warnings -vv -e "DROP TABLE IF EXISTS ol_base; CREATE TABLE ol_base (type CHAR(40) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL, ol_key CHAR(250) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL, revision INTEGER NOT NULL, last_modified DATETIME NOT NULL, json JSON NOT NULL) ENGINE=MyISAM; LOAD DATA LOCAL INFILE '/dev/stdin' INTO TABLE ol_base FIELDS TERMINATED BY '\t' ENCLOSED BY '' ESCAPED BY '';"

mariadb -u root -ppassword allthethings --show-warnings -vv < /scripts/helpers/openlib_final.sql
