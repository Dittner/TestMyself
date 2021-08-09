SELECT COUNT(id)
FROM note
WHERE (isExample = 1 AND :loadExamples = 1 AND searchText LIKE :searchText AND vocabularyID in #allVocabularyList)
OR (isExample = 0 AND searchText LIKE :searchText AND vocabularyID in #selectedVocabularyList)