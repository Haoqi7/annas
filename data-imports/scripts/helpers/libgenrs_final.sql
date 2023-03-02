DROP TRIGGER libgen_description_update_all;
DROP TRIGGER libgen_updated_update_all;

# Double-check that the new tables indeed exist, before we start dropping a bunch of existing tables.
SELECT * FROM updated LIMIT 1;
SELECT * FROM description LIMIT 1;
SELECT * FROM hashes LIMIT 1;
SELECT * FROM fiction LIMIT 1;
SELECT * FROM fiction_description LIMIT 1;
SELECT * FROM fiction_hashes LIMIT 1;
SELECT * FROM topics LIMIT 1;
DROP TABLE IF EXISTS allthethings.libgenrs_updated;
DROP TABLE IF EXISTS allthethings.libgenrs_description;
DROP TABLE IF EXISTS allthethings.libgenrs_hashes;
DROP TABLE IF EXISTS allthethings.libgenrs_fiction;
DROP TABLE IF EXISTS allthethings.libgenrs_fiction_description;
DROP TABLE IF EXISTS allthethings.libgenrs_fiction_hashes;
DROP TABLE IF EXISTS allthethings.libgenrs_topics;

ALTER TABLE updated RENAME libgenrs_updated;
ALTER TABLE description RENAME libgenrs_description;
ALTER TABLE hashes RENAME libgenrs_hashes;
ALTER TABLE fiction RENAME libgenrs_fiction;
ALTER TABLE fiction_description RENAME libgenrs_fiction_description;
ALTER TABLE fiction_hashes RENAME libgenrs_fiction_hashes;
ALTER TABLE topics RENAME libgenrs_topics;

-- TODO: Dropping these indices right after creating them is pretty inefficient. Would be better
-- to modify the incoming SQL in the first place to not set them.
SET SESSION sql_mode = 'NO_ENGINE_SUBSTITUTION';
ALTER TABLE libgenrs_description DROP INDEX `time`;
ALTER TABLE libgenrs_hashes ADD PRIMARY KEY(md5);
ALTER TABLE libgenrs_hashes DROP INDEX `MD5`; -- Using primary key instead.
ALTER TABLE libgenrs_updated DROP INDEX `Generic`, DROP INDEX `VisibleTimeAdded`, DROP INDEX `TimeAdded`, DROP INDEX `Topic`, DROP INDEX `VisibleID`, DROP INDEX `VisibleTimeLastModified`, DROP INDEX `TimeLastModifiedID`, DROP INDEX `DOI_INDEX`, DROP INDEX `Identifier`, DROP INDEX `Language`, DROP INDEX `Title`, DROP INDEX `Author`, DROP INDEX `Language_FTS`, DROP INDEX `Extension`, DROP INDEX `Publisher`, DROP INDEX `Series`, DROP INDEX `Year`, DROP INDEX `Title1`, DROP INDEX `Tags`, DROP INDEX `Identifierfulltext`;
ALTER TABLE libgenrs_fiction DROP INDEX `Language`, DROP INDEX `TITLE`, DROP INDEX `Authors`, DROP INDEX `Series`, DROP INDEX `Title+Authors+Series`, DROP INDEX `Identifier`;

-- TODO: Also not very efficient..
DROP TABLE description_edited;
DROP TABLE updated_edited;
