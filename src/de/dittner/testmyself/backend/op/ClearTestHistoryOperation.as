package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.test.Test;

public class ClearTestHistoryOperation extends AsyncOperation implements IAsyncCommand {

	public function ClearTestHistoryOperation(storage:SQLStorage, test:Test, notesIDs:Array) {
		super();
		this.storage = storage;
		this.test = test;
		this.notesIDs = notesIDs;
	}

	private var storage:SQLStorage;
	private var test:Test;
	private var notesIDs:Array;
	private var composite:CompositeCommand;

	public function execute():void {
		if (notesIDs.length > 0) {
			composite = new CompositeCommand();

			for each(var noteID:int in notesIDs) {
				composite.addOperation(ClearTestHistoryOperationPhase, test.id, noteID, storage.sqlConnection, test);
			}

			composite.addCompleteCallback(completeHandler);
			composite.execute();
		}
		else dispatchSuccess();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
		test = null;
		notesIDs = null;
		composite = null;
	}
}
}