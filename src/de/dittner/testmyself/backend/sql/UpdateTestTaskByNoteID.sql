UPDATE testTask
SET
	rate = :rate,
	complexity = :complexity,
	isFailed = :isFailed,
	lastTestedDate = :lastTestedDate
WHERE testID = :testID
AND noteID = :noteID