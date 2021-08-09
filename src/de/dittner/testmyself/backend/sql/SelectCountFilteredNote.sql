SELECT COUNT(id) FROM note
WHERE vocabularyID = :vocabularyID
AND isExample = 0
AND tags LIKE :selectedTagID