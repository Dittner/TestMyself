SELECT t.id
FROM note n, testTask t, note pn
WHERE t.testID = :testID
AND n.parentID = pn.id
AND t.complexity = :complexity
AND t.noteID = n.id
AND pn.tags LIKE :selectedTagID
ORDER BY rate