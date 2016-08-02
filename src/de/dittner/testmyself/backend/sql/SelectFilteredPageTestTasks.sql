SELECT t.*
FROM filter f, testTask t
WHERE t.testID = :selectedTestID
AND t.complexity = :selectedTaskComplexity
AND (:onlyFailedNotes = 0 OR t.isFailed = :onlyFailedNotes)
AND t.noteID = f.noteID
AND f.themeID = :selectedThemeID
ORDER BY t.lastTestedDate DESC
LIMIT :startIndex, :amount