SELECT t.*
FROM test t, note n
WHERE t.testID = :selectedTestID
AND t.noteID = n.id
AND t.complexity = :complexity
AND (n.audioComment IS NOT NULL OR :ignoreAudio)
ORDER BY t.rate DESC