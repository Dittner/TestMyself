UPDATE transUnit
SET
	origin = :origin,
	translation = :translation,
	audioRecord = :audioRecord
WHERE id = :updatingTransUnitID