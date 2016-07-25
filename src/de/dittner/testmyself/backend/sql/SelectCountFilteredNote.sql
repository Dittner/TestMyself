SELECT COUNT(n.id) FROM note n, filter f
WHERE vocabularyID = :vocabularyID
AND n.isExample = 0
AND n.id = f.noteID
AND f.themeID = :selectedThemeID