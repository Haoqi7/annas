# Double-check that the new tables indeed exist, before we start dropping a bunch of existing tables.
SELECT * FROM allthethings.books LIMIT 1;
SELECT * FROM allthethings.isbn LIMIT 1;
DROP TABLE IF EXISTS allthethings.zlib_book;
DROP TABLE IF EXISTS allthethings.zlib_isbn;;

RENAME TABLE allthethings.books TO allthethings.zlib_book;
RENAME TABLE allthethings.isbn TO allthethings.zlib_isbn;
