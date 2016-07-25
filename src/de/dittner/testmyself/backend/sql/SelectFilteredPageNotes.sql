SELECT n.*
FROM note n, filter f
WHERE vocabularyID = :vocabularyID
AND n.isExample = 0
AND n.id = f.noteID
AND f.themeID = :selectedThemeID
ORDER BY n.id DESC
LIMIT :startIndex, :amount