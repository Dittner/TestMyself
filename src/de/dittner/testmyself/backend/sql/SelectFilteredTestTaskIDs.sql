SELECT t.id
FROM note n, testTask t
WHERE t.testID = :selectedTestID
AND t.complexity = :complexity
AND t.noteID = n.id
AND n.tags LIKE :selectedTagID
ORDER BY rate