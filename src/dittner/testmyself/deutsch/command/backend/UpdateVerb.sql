UPDATE note
SET
	title = :title,
	description = :description,
	audioComment = :audioComment,
	present = :present,
	past = :past,
	perfect = :perfect
WHERE id = :updatingNoteID