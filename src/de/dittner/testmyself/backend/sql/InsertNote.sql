INSERT INTO note
(
	title,
	description,
	isExample,
	vocabularyID,
	parentID,
	searchText,
	options,
	hasAudio
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
	:hasAudio
)