CREATE TABLE IF NOT EXISTS tag
(
	id int PRIMARY KEY AUTOINCREMENT,
	vocabularyID int,
	name String NOT NULL
)