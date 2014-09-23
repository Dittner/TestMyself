SELECT t.*
FROM test t, note n
WHERE t.testID = :selectedTestID
AND t.noteID = n.id
AND (n.audioComment IS NOT NULL OR :ignoreAudio)
ORDER BY #priority