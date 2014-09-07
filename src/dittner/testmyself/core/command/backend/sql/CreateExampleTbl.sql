CREATE TABLE example
(
	id int PRIMARY KEY AUTOINCREMENT,
	noteID int NOT NULL,
	title String NOT NULL,
	description String NOT NULL,
	audioComment Object
)