package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.ClearTestHistoryOperation;
import de.dittner.testmyself.backend.op.SelectTestNotesIDsOperation;
import de.dittner.testmyself.model.domain.test.Test;

public class ClearTestHistoryCmd extends AsyncOperation implements IAsyncCommand {

	public function ClearTestHistoryCmd(storage:Storage, test:Test) {
		this.storage = storage;
		this.test = test;
	}

	private var storage:Storage;
	private var test:Test;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		var notesIDs:Array = [];
		composite.addOperation(SelectTestNotesIDsOperation, storage, test, notesIDs);
		composite.addOperation(ClearTestHistoryOperation, storage, test, notesIDs);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}
}
}