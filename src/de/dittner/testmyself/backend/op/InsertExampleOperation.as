package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.Note;

public class InsertExampleOperation extends AsyncOperation implements IAsyncCommand {

	public function InsertExampleOperation(storage:Storage, parentNote:Note) {
		this.parentNote = parentNote;
		this.storage = storage;
		this.examples = parentNote.examples;
	}

	private var parentNote:Note;
	private var examples:Array;
	private var storage:Storage;

	public function execute():void {
		if (examples && examples.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var example:Note in examples) {
				example.parentID = parentNote.id;
				composite.addOperation(MP3EncodingOperation, example.audioComment);
				composite.addOperation(InsertExampleOperationPhase, storage, example);
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
		storage = null;
	}
}
}