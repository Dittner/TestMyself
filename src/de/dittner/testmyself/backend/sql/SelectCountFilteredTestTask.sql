SELECT COUNT(t.testID)
FROM filter f, test t
WHERE t.testID = :selectedTestID
AND (:onlyFailedNotes = 0 OR t.isFailed = :onlyFailedNotes)
AND t.noteID = f.noteID
AND f.themeID = :selectedThemeID