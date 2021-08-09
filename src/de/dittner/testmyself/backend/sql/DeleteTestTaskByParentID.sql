DELETE
FROM testTask
WHERE noteID
IN
(SELECT n.id FROM note n
WHERE n.parentID = :parentID)