INSERT INTO note
(
	title,
	description,
	isExample,
	vocabularyID,
	parentID,
	searchText,
	options,
	audioComment
)
VALUES
(
	:title,
	:description,
	:isExample,
	:vocabularyID,
	:parentID,
	:searchText,
	:options,
	:audioComment
)