SELECT COUNT(t.testID)
FROM note n, filter f, theme th, test t
WHERE t.testID = :selectedTestID
AND (:onlyFailedNotes = 0 OR t.isFailed = :onlyFailedNotes)
AND t.noteID = n.id
AND n.id = f.noteID
AND f.themeID = th.id
AND th.name
IN #filterList