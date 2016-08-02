SELECT t.id
FROM filter f, testTask t
WHERE t.testID = :selectedTestID
AND t.complexity = :complexity
AND t.noteID = f.noteID
AND f.themeID = :selectedThemeID
ORDER BY rate