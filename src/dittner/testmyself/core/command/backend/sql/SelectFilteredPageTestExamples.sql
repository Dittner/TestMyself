SELECT e.*
FROM example e, testExample t
WHERE t.noteID = e.id
AND (:onlyFailedNotes = 0 OR t.isFailed = :onlyFailedNotes)
AND t.testID = :selectedTestID
AND e.noteID
IN
(
   SELECT n.id
   FROM note n, filter f, theme th
   WHERE n.id = f.noteID
   AND f.themeID = th.id
   AND th.name
   IN #filterList
)
ORDER BY rate
LIMIT :startIndex, :amount