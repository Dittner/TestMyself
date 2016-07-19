package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.op.DeleteExampleByParentIDOperationPhase;
import de.dittner.testmyself.backend.op.DeleteFilterByNoteIDOperationPhase;
import de.dittner.testmyself.backend.op.DeleteNoteOperationPhase;
import de.dittner.testmyself.backend.op.DeleteTestTaskByNoteIDOperationPhase;

public class RemoveNoteCmd extends AsyncOperation implements IAsyncCommand {

	public function RemoveNoteCmd(storage:SQLStorage, noteID:int) {
		super();
		this.storage = storage;
		this.noteID = noteID;
	}

	private var storage:SQLStorage;
	private var noteID:int;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(DeleteNoteOperationPhase, storage.sqlConnection, noteID);
		composite.addOperation(DeleteFilterByNoteIDOperationPhase, storage.sqlConnection, noteID);
		composite.addOperation(DeleteTestTaskByNoteIDOperationPhase, storage.sqlConnection, noteID);
		composite.addOperation(DeleteExampleByParentIDOperationPhase, storage.sqlConnection, noteID);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess();
		else dispatchError(op.error);
	}

}
}