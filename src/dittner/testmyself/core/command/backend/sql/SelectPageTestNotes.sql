SELECT n.*
FROM test t, note n
WHERE t.noteID = n.ID
AND (:onlyFailedNotes = 0 OR t.isFailed = :onlyFailedNotes)
AND t.testID = :selectedTestID
ORDER BY t.lastTestedDate DESC
LIMIT :startIndex, :amount