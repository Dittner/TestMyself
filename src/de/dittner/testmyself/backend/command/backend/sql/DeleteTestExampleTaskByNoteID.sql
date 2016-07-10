DELETE
FROM testExample
WHERE noteID
IN
(SELECT id FROM example
WHERE noteID = :deletingNoteID)