SELECT *
FROM test
WHERE testID = :selectedTestID
ORDER BY balance
LIMIT :startIndex, :amount