SELECT *
FROM testExample
WHERE testID = :selectedTestID
AND (:onlyFailedNotes = 0 OR isFailed = :onlyFailedNotes)
AND noteID
IN
(
   SELECT id FROM example
   WHERE noteID
   IN
   (
      SELECT n.id
      FROM note n, filter f, theme th
      WHERE n.id = f.noteID
      AND f.themeID = th.id
      AND th.name
      IN #filterList
   )
)
ORDER BY rate
LIMIT :startIndex, :amount