CREATE TABLE note
(
	id int PRIMARY KEY AUTOINCREMENT,
	title String NOT NULL,
	description String,
	audioComment Object,
	present String NOT NULL,
	past String NOT NULL,
	perfect String NOT NULL
)