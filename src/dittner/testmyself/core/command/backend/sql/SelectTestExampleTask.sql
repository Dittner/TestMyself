SELECT t.*
FROM testExample t, example e
WHERE t.testID = :selectedTestID
AND t.noteID = e.id
AND (e.audioComment IS NOT NULL OR :ignoreAudio)
AND t.complexity = :complexity
ORDER BY t.rate