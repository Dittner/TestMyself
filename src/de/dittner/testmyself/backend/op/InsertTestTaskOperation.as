package de.dittner.testmyself.backend.op {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.Test;

public class InsertTestTaskOperation extends StorageOperation implements IAsyncCommand {

	public function InsertTestTaskOperation(storage:Storage, note:Note) {
		this.storage = storage;
		this.note = note;
		this.availableTests = note.vocabulary.availableTests;
	}

	private var storage:Storage;
	private var note:Note;
	private var availableTests:Array;

	public function execute():void {
		if (availableTests.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var test:Test in availableTests) {
				if (test.isValidForTest(note))
					composite.addOperation(InsertTestTaskOperationPhase, storage, note, test);

				for each(var example:Note in note.exampleColl)
					if (test.isValidForTest(example))
						composite.addOperation(InsertTestTaskOperationPhase, storage, example, test);

			}

			composite.addCompleteCallback(completeHandler);
			composite.execute();
		}
		else dispatchSuccess();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError();
	}

	override public function destroy():void {
		super.destroy();
		note = null;
		storage = null;
	}
}
}