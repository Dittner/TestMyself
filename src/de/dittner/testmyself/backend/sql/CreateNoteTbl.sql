CREATE TABLE IF NOT EXISTS note
(
	id int PRIMARY KEY AUTOINCREMENT,
	vocabularyID int NOT NULL,
	parentID int NOT NULL,
	title String NOT NULL,
	description String NOT NULL,
	audioComment Object,
	options Object,
	hasAudio int NOT NULL,
	isExample int NOT NULL,
	searchText String NOT NULL

)