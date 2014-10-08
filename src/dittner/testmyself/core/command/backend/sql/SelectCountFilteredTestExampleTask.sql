SELECT COUNT(t.testID)
FROM note n, filter f, theme th, testExample t
WHERE t.testID = :selectedTestID
AND t.noteID = n.id
AND n.id = f.noteID
AND f.themeID = th.id
AND th.name
IN #filterList