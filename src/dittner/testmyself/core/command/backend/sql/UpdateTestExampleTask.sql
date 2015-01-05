UPDATE testExample
SET
	testID = :testID,
	noteID = :noteID,
	correct = :correct,
	incorrect = :incorrect,
	rate = :rate,
	complexity = :complexity
WHERE testID = :updatingTestID
AND noteID = :updatingNoteID