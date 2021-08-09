CREATE TABLE IF NOT EXISTS testTask
(
	id int PRIMARY KEY AUTOINCREMENT,
	testID int NOT NULL,
	noteID int NOT NULL,
	rate int NOT NULL,
	complexity int NOT NULL,
	isFailed int NOT NULL,
	lastTestedDate int NOT NULL
)