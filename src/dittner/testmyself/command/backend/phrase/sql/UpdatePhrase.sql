UPDATE phrase
SET
	origin = :origin,
	translation = :translation,
	audioRecord = :audioRecord
WHERE id = :updatingPhraseID