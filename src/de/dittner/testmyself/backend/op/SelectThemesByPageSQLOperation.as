package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.ui.common.page.IPageInfo;

public class SelectThemesByPageSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectThemesByPageSQLOperation(storage:SQLStorage, page:IPageInfo) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:SQLStorage;
	private var page:IPageInfo;

	public function execute():void {
		if (page.notes.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var note:Note in page.notes)
				composite.addOperation(SelectNoteThemesSQLOperation, storage, note);

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