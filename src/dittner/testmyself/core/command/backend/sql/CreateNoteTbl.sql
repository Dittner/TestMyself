CREATE TABLE note
(
	id int PRIMARY KEY AUTOINCREMENT,
	title String NOT NULL,
	description String NOT NULL,
	audioComment BLOB
)