SELECT *
FROM note
WHERE langID = :langID AND searchText LIKE :searchText
ORDER BY isExample, vocabularyID, id DESC
LIMIT :startIndex, :amount