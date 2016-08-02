SELECT id
FROM testTask
WHERE testID = :selectedTestID
AND complexity = :complexity
ORDER BY rate