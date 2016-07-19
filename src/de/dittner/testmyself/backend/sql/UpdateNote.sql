UPDATE note
SET
	title = :title,
	description = :description,
	isExample = :isExample,
	vocabularyID = :vocabularyID,
	parentID = :parentID,
	searchText = :searchText,
	options = :options,
	audioComment = :audioComment
WHERE id = :updatingNoteID