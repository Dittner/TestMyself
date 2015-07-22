UPDATE testExample
SET
	testID = :testID,
	noteID = :noteID,
	correct = :correct,
	incorrect = :incorrect,
	rate = :rate,
	complexity = :complexity,
	isFailed = :isFailed,
	lastTestedDate = :lastTestedDate
WHERE testID = :updatingTestID
AND noteID = :updatingNoteID