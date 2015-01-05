SELECT *
FROM test
WHERE testID = :selectedTestID
ORDER BY rate
LIMIT :startIndex, :amount