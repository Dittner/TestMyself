UPDATE note
SET
	title = :title,
	description = :description,
	audioComment = :audioComment,
	article = :article,
	options = :options
WHERE id = :updatingNoteID