SELECT e.*
FROM example e, testExample t
WHERE t.noteID = e.id
AND t.testID = :selectedTestID
ORDER BY balance
LIMIT :startIndex, :amount