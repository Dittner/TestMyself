UPDATE test
SET
	testID = :testID,
	noteID = :noteID,
	balance = :balance,
	balanceIndex = :balanceIndex,
	amount = :amount,
	amountIndex = :amountIndex
WHERE testID = :updatingTestID
AND noteID = :updatingNoteID