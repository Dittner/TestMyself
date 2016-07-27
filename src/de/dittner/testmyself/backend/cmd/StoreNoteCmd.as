package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.op.DeleteExampleByParentIDOperation;
import de.dittner.testmyself.backend.op.DeleteFilterByNoteIDOperation;
import de.dittner.testmyself.backend.op.DeleteTestTaskByNoteIDOperation;
import de.dittner.testmyself.backend.op.InsertExampleOperation;
import de.dittner.testmyself.backend.op.InsertFilterOperation;
import de.dittner.testmyself.backend.op.InsertNoteOperation;
import de.dittner.testmyself.backend.op.InsertTestTaskOperation;
import de.dittner.testmyself.backend.op.InsertThemeOperation;
import de.dittner.testmyself.backend.op.MP3EncodingOperation;
import de.dittner.testmyself.backend.op.UpdateNoteOperation;
import de.dittner.testmyself.model.domain.note.Note;

public class StoreNoteCmd extends AsyncOperation implements IAsyncCommand {

	public function StoreNoteCmd(storage:SQLStorage, note:Note) {
		this.storage = storage;
		this.note = note;
	}

	private var storage:SQLStorage;
	private var note:Note;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(MP3EncodingOperation, note.audioComment);
		if (note.isNew) {
			composite.addOperation(InsertNoteOperation, storage.sqlConnection, note);
		}
		else {
			composite.addOperation(UpdateNoteOperation, storage.sqlConnection, note);
			composite.addOperation(DeleteFilterByNoteIDOperation, storage.sqlConnection, note);
			composite.addOperation(DeleteTestTaskByNoteIDOperation, storage.sqlConnection, note);
			composite.addOperation(DeleteExampleByParentIDOperation, storage.sqlConnection, note);
		}
		composite.addOperation(InsertThemeOperation, storage.sqlConnection, note);
		composite.addOperation(InsertFilterOperation, storage.sqlConnection, note);
		composite.addOperation(InsertExampleOperation, storage.sqlConnection, note);
		composite.addOperation(InsertTestTaskOperation, storage.sqlConnection, note);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess();
		else dispatchError(op.error);
	}
}
}