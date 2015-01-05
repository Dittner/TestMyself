SELECT *
FROM testExample
WHERE testID = :selectedTestID
ORDER BY rate
LIMIT :startIndex, :amount