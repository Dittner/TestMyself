UPDATE phrase
SET
	origin = :origin,
	translation = :translation,
	audioRecordID = :audioRecordID
WHERE id = :updatingPhraseID