SELECT *
FROM note
WHERE vocabularyID = :vocabularyID
AND isExample = 0
AND tags LIKE :selectedTagID
ORDER BY id DESC
LIMIT :startIndex, :amount