package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.op.CountFilteredNoteByPageOperation;
import de.dittner.testmyself.backend.op.SelectExamplesByPageOperation;
import de.dittner.testmyself.backend.op.SelectNotesByPageOperation;
import de.dittner.testmyself.backend.op.SelectThemesByPageOperation;
import de.dittner.testmyself.ui.common.page.NotePageInfo;

public class LoadNotePageCmd extends AsyncOperation implements IAsyncCommand {

	public function LoadNotePageCmd(storage:SQLStorage, page:NotePageInfo) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:SQLStorage;
	private var page:NotePageInfo;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(SelectNotesByPageOperation, storage, page);
		composite.addOperation(SelectExamplesByPageOperation, storage, page);
		composite.addOperation(SelectThemesByPageOperation, storage, page);
		composite.addOperation(CountFilteredNoteByPageOperation, storage, page);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(page);
		else dispatchError(op.error);
	}
}
}