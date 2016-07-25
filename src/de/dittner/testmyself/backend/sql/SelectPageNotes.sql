SELECT *
FROM note
WHERE isExample = 0 vocabularyID = :vocabularyID
ORDER BY id DESC
LIMIT :startIndex, :amount