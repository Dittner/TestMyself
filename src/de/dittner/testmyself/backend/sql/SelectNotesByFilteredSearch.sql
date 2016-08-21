SELECT *
FROM note
WHERE (isExample = 1 AND :loadExamples = 1 AND searchText LIKE :searchText)
OR (isExample = 0 AND searchText LIKE :searchText AND vocabularyID in #selectedVocabularyList)
ORDER BY isExample, vocabularyID, id DESC
LIMIT :startIndex, :amount