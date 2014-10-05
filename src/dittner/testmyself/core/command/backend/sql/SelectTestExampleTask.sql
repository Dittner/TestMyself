SELECT t.*
FROM testExample t, example e
WHERE t.testID = :selectedTestID
AND t.noteID = e.id
AND (e.audioComment IS NOT NULL OR :ignoreAudio)
ORDER BY #priority