#!/bin/bash

set -Eeuxo pipefail

# Run this script by running: docker exec -it aa-data-import--mariadb /scripts/pilimi_isbndb.sh
# Feel free to comment out steps in order to retry failed parts of this script, when necessary.

# aria2c torrent downloading is sadly not idempotent, and crashes when the torrent is already downloaded;
# so just comment out those lines if you need to rerun.

cd /temp-dir

# isbndb_2022_09.torrent
aria2c --seed-time=0 'magnet:?xt=urn:btih:086254d4009c960d100fb5a1ec31736e82373d8b&dn=isbndb%5F2022%5F09.jsonl.gz&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2810%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A6969%2Fannounce&tr=http%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&tr=http%3A%2F%2F95.107.48.115%3A80%2Fannounce&tr=http%3A%2F%2Fopen.acgnxtracker.com%3A80%2Fannounce&tr=http%3A%2F%2Ft.acg.rip%3A6699%2Fannounce&tr=http%3A%2F%2Ft.nyaatracker.com%3A80%2Fannounce&tr=http%3A%2F%2Ftracker.bt4g.com%3A2095%2Fannounce&tr=http%3A%2F%2Ftracker.files.fm%3A6969%2Fannounce&tr=http%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=http%3A%2F%2Fvps02.net.orel.ru%3A80%2Fannounce&tr=https%3A%2F%2F1337.abcvg.info%3A443%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce&tr=https%3A%2F%2Ftracker.nanoha.org%3A443%2Fannounce&tr=https%3A%2F%2Ftracker.sloppyta.co%3A443%2Fannounce&tr=udp%3A%2F%2F208.83.20.20%3A6969%2Fannounce&tr=udp%3A%2F%2F37.235.174.46%3A2710%2Fannounce&tr=udp%3A%2F%2F75.127.14.224%3A2710%2Fannounce&tr=udp%3A%2F%2Fexodus.desync.com%3A6969%2Fannounce&tr=udp%3A%2F%2Fexplodie.org%3A6969%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Fmovies.zsw.ca%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.demonii.com%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Fpublic.tracker.vraphim.com%3A6969%2Fannounce&tr=udp%3A%2F%2Fretracker.lanta-net.ru%3A2710%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.filemail.com%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.pomf.se%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.swateam.org.uk%3A2710%2Fannounce&tr=udp%3A%2F%2Ftracker.tiny-vps.com%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce'

pv isbndb_2022_09.jsonl.gz | zcat | python3 /scripts/helpers/pilimi_isbndb.py > pilimi_isbndb_processed.csv

# Seems much faster to add the indexes right away than to omit them first and add them later.
pv pilimi_isbndb_processed.csv | mariadb -u root -ppassword allthethings --local-infile=1 --show-warnings -vv -e "DROP TABLE IF EXISTS isbndb_isbns; CREATE TABLE isbndb_isbns (isbn13 CHAR(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL, isbn10 CHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL, json longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(json)), PRIMARY KEY (isbn13,isbn10), KEY isbn10 (isbn10)) ENGINE=MyISAM; LOAD DATA LOCAL INFILE '/dev/stdin' INTO TABLE isbndb_isbns FIELDS TERMINATED BY '\t' ENCLOSED BY '' ESCAPED BY '';"
