CREATE TABLE transUnit
(
	id int PRIMARY KEY AUTOINCREMENT,
	origin String NOT NULL,
	translation String NOT NULL,
	audioRecord BLOB
)