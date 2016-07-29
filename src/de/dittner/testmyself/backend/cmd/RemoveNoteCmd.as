package de.dittner.testmyself.backend.cmd {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.DeleteExampleByParentIDOperation;
import de.dittner.testmyself.backend.op.DeleteFilterByNoteIDOperation;
import de.dittner.testmyself.backend.op.DeleteNoteOperation;
import de.dittner.testmyself.backend.op.DeleteTestTaskByNoteIDOperation;
import de.dittner.testmyself.backend.op.StorageOperation;

public class RemoveNoteCmd extends StorageOperation implements IAsyncCommand {

	public function RemoveNoteCmd(storage:Storage, noteID:int) {
		super();
		this.storage = storage;
		this.noteID = noteID;
	}

	private var storage:Storage;
	private var noteID:int;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(DeleteNoteOperation, storage, noteID);
		composite.addOperation(DeleteFilterByNoteIDOperation, storage, noteID);
		composite.addOperation(DeleteTestTaskByNoteIDOperation, storage, noteID);
		composite.addOperation(DeleteExampleByParentIDOperation, storage, noteID);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess();
		else dispatchError();
	}

}
}