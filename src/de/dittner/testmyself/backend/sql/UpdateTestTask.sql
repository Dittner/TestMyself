UPDATE testTask
SET
	rate = :rate,
	complexity = :complexity,
	isFailed = :isFailed,
	lastTestedDate = :lastTestedDate
WHERE id = :taskID