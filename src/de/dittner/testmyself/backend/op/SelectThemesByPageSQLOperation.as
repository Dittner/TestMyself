package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.page.NotePageInfo;

public class SelectThemesByPageSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectThemesByPageSQLOperation(storage:SQLStorage, page:NotePageInfo) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:SQLStorage;
	private var page:NotePageInfo;

	public function execute():void {
		if (page.notes.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var note:Note in page.notes)
				composite.addOperation(SelectNoteThemesSQLOperation, storage, page.vocabulary, note);

			composite.addCompleteCallback(completeHandler);
			composite.execute();
		}
		else dispatchSuccess();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(page);
		else dispatchError(op.error);
	}
}
}