SELECT id
FROM testTask
WHERE testID = :testID
AND complexity = :complexity
ORDER BY rate