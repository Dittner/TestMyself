SELECT *
FROM note
WHERE searchText LIKE :searchText
ORDER BY isExample, vocabularyID, id DESC
LIMIT :startIndex, :amount