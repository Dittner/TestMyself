package de.dittner.testmyself.backend.op {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.ui.common.page.INotePage;

public class SelectThemesByPageOperation extends StorageOperation implements IAsyncCommand {

	public function SelectThemesByPageOperation(storage:Storage, page:INotePage) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:INotePage;

	public function execute():void {
		if (page.noteColl.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var note:Note in page.noteColl)
				composite.addOperation(SelectNoteThemesOperation, storage, note);

			composite.addCompleteCallback(completeHandler);
			composite.execute();
		}
		else {
			dispatchSuccess();
		}
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(page);
		else dispatchError();
	}
}
}