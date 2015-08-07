SELECT e.*
FROM example e, testExample t
WHERE t.noteID = e.id
AND (:onlyFailedNotes = 0 OR t.isFailed = :onlyFailedNotes)
AND t.testID = :selectedTestID
ORDER BY lastTestedDate DESC
LIMIT :startIndex, :amount