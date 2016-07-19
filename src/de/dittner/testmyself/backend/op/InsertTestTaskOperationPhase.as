package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.Test;

import flash.data.SQLConnection;

public class InsertTestTaskOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function InsertTestTaskOperationPhase(conn:SQLConnection, note:Note) {
		this.conn = conn;
		this.note = note;
		this.availableTests = note.vocabulary.availableTests;
	}

	private var conn:SQLConnection;
	private var note:Note;
	private var availableTests:Array;

	public function execute():void {
		if (availableTests.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var test:Test in availableTests) {
				if (test.isValidForTest(note))
					composite.addOperation(InsertTestTaskOperationSubPhase, conn, note, test);

				for each(var example:Note in note.examples)
					if (test.isValidForTest(example))
						composite.addOperation(InsertTestTaskOperationSubPhase, conn, example, test);

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
		note = null;
		conn = null;
	}
}
}