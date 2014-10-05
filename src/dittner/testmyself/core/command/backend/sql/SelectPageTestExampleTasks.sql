SELECT *
FROM testExample
WHERE testID = :selectedTestID
ORDER BY balance
LIMIT :startIndex, :amount