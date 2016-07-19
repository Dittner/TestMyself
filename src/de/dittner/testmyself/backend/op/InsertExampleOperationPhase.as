package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.Note;

import flash.data.SQLConnection;

public class InsertExampleOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function InsertExampleOperationPhase(conn:SQLConnection, parentNote:Note) {
		this.parentNote = parentNote;
		this.conn = conn;
		this.examples = parentNote.examples;
	}

	private var parentNote:Note;
	private var examples:Array;
	private var conn:SQLConnection;

	public function execute():void {
		if (examples && examples.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var example:Note in examples) {
				example.parentID = parentNote.id;
				composite.addOperation(MP3EncodingOperationPhase, example.audioComment);
				composite.addOperation(InsertExampleOperationSubPhase, conn, example);
			}
			composite.addCompleteCallback(completeHandler);
			composite.execute();
		}
		else dispatchSuccess();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) {
			dispatchSuccess(op.result);
		}
		else {
			CLog.err(LogCategory.STORAGE, op.error);
			dispatchError(op.error);
		}
	}

	override public function destroy():void {
		super.destroy();
		examples = null;
		conn = null;
	}
}
}