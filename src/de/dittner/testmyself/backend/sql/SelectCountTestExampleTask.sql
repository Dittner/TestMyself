SELECT COUNT(testID)
FROM testExample
WHERE testID = :selectedTestID
AND (:onlyFailedNotes = 0 OR isFailed = :onlyFailedNotes)