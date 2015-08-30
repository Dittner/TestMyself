SELECT t.*
FROM test t, note n, filter f, theme th
WHERE t.testID = :selectedTestID
AND t.noteID = n.id
AND (n.audioComment IS NOT NULL OR :ignoreAudio)
AND t.complexity = :complexity
AND n.id = f.noteID
AND f.themeID = th.id
AND th.name
IN #filterList
ORDER BY t.rate DESC