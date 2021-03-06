SELECT *
FROM test
WHERE testID = :selectedTestID
AND (:onlyFailedNotes = 0 OR isFailed = :onlyFailedNotes)
ORDER BY lastTestedDate DESC
LIMIT :startIndex, :amount