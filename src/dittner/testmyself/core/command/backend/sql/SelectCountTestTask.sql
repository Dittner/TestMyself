SELECT COUNT(testID)
FROM test
WHERE testID = :selectedTestID
AND (:onlyFailedNotes = 0 OR isFailed = :onlyFailedNotes)
