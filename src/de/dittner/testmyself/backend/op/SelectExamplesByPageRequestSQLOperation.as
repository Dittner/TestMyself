package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.page.NotePageRequest;

public class SelectExamplesByPageRequestSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectExamplesByPageRequestSQLOperation(storage:SQLStorage, pageRequest:NotePageRequest) {
		super();
		this.storage = storage;
		this.pageRequest = pageRequest;
	}

	private var storage:SQLStorage;
	private var pageRequest:NotePageRequest;

	public function execute():void {
		if (pageRequest.notes.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var note:Note in pageRequest.notes)
				composite.addOperation(SelectExamplesSQLOperation, storage, pageRequest.vocabulary, note);

			composite.addCompleteCallback(completeHandler);
			composite.execute();
		}
		else dispatchSuccess();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(pageRequest);
		else dispatchError(op.error);
	}
}
}