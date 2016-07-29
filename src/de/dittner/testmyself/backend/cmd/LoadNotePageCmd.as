package de.dittner.testmyself.backend.cmd {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.CountFilteredNoteByPageOperation;
import de.dittner.testmyself.backend.op.SelectExamplesByPageOperation;
import de.dittner.testmyself.backend.op.SelectNotesByPageOperation;
import de.dittner.testmyself.backend.op.SelectThemesByPageOperation;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.ui.common.page.NotePageInfo;

public class LoadNotePageCmd extends StorageOperation implements IAsyncCommand {

	public function LoadNotePageCmd(storage:Storage, page:NotePageInfo) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:NotePageInfo;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(SelectNotesByPageOperation, storage, page);
		composite.addOperation(SelectExamplesByPageOperation, storage, page);
		composite.addOperation(SelectThemesByPageOperation, storage, page);
		if (page.countAllNotes)
			composite.addOperation(CountFilteredNoteByPageOperation, storage, page);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(page);
		else dispatchError();
	}
}
}