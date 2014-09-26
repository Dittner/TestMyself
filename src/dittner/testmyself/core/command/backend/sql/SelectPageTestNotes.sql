SELECT n.*
FROM test t, note n
WHERE t.noteID = n.ID
AND t.testID = :selectedTestID
ORDER BY t.balance
LIMIT :startIndex, :amount