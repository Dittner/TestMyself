SELECT COUNT(t.testID)
FROM note n, testTask t
WHERE t.testID = :selectedTestID
AND (:onlyFailedNotes = 0 OR t.isFailed = :onlyFailedNotes)
AND t.noteID = n.id
AND n.tags LIKE :selectedTagID