SELECT *
FROM testExample
WHERE testID = :selectedTestID
AND noteID
IN
(
   SELECT id FROM example
   WHERE (audioComment IS NOT NULL OR :ignoreAudio)
   AND noteID
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
ORDER BY #priority