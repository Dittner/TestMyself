package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.op.DeleteExampleByParentIDOperationPhase;
import de.dittner.testmyself.backend.op.DeleteFilterByNoteIDOperationPhase;
import de.dittner.testmyself.backend.op.DeleteTestTaskByNoteIDOperationPhase;
import de.dittner.testmyself.backend.op.InsertExampleOperationPhase;
import de.dittner.testmyself.backend.op.InsertFilterOperationPhase;
import de.dittner.testmyself.backend.op.InsertNoteOperationPhase;
import de.dittner.testmyself.backend.op.InsertTestTaskOperationPhase;
import de.dittner.testmyself.backend.op.InsertThemeOperationPhase;
import de.dittner.testmyself.backend.op.MP3EncodingOperationPhase;
import de.dittner.testmyself.backend.op.UpdateNoteOperationPhase;
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

		composite.addOperation(MP3EncodingOperationPhase, note.audioComment);
		if (note.isNew) {
			composite.addOperation(InsertNoteOperationPhase, storage.sqlConnection, note);
		}
		else {
			composite.addOperation(UpdateNoteOperationPhase, storage.sqlConnection, note);
			composite.addOperation(DeleteFilterByNoteIDOperationPhase, storage.sqlConnection, note);
			composite.addOperation(DeleteTestTaskByNoteIDOperationPhase, storage.sqlConnection, note);
			composite.addOperation(DeleteExampleByParentIDOperationPhase, storage.sqlConnection, note);
		}
		composite.addOperation(InsertThemeOperationPhase, storage.sqlConnection, note);
		composite.addOperation(InsertFilterOperationPhase, storage.sqlConnection, note);
		composite.addOperation(InsertExampleOperationPhase, storage.sqlConnection, note);
		composite.addOperation(InsertTestTaskOperationPhase, storage.sqlConnection, note);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess();
		else dispatchError(op.error);
	}
}
}