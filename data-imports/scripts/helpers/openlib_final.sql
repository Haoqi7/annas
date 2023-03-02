-- ~37 mins
ALTER TABLE allthethings.ol_base ADD PRIMARY KEY(ol_key);

-- ~20mins
CREATE TABLE allthethings.ol_isbn13 (PRIMARY KEY(isbn, ol_key)) ENGINE=MyISAM IGNORE SELECT x.isbn AS isbn, ol_key FROM allthethings.ol_base b CROSS JOIN JSON_TABLE(b.json, '$.isbn_13[*]' COLUMNS (isbn CHAR(13) PATH '$')) x WHERE ol_key LIKE '/books/OL%';
