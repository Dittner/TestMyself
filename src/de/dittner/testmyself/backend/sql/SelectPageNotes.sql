SELECT *
FROM note
WHERE isExample = 0 AND vocabularyID = :vocabularyID
ORDER BY id DESC
LIMIT :startIndex, :amount