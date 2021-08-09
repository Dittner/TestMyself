INSERT INTO testTask
(
	testID,
	noteID,
	rate,
	complexity,
	isFailed,
	lastTestedDate
)
VALUES
(
	:testID,
	:noteID,
	:rate,
	:complexity,
	:isFailed,
	:lastTestedDate
)