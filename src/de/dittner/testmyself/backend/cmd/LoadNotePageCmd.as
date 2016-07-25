package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.op.CountFilteredNoteByPageOperationPhase;
import de.dittner.testmyself.backend.op.SelectExamplesByPageSQLOperation;
import de.dittner.testmyself.backend.op.SelectNotesByPageOperationPhase;
import de.dittner.testmyself.backend.op.SelectThemesByPageSQLOperation;
import de.dittner.testmyself.model.page.NotePageInfo;

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

		composite.addOperation(SelectNotesByPageOperationPhase, storage, page);
		composite.addOperation(SelectExamplesByPageSQLOperation, storage, page);
		composite.addOperation(SelectThemesByPageSQLOperation, storage, page);
		composite.addOperation(CountFilteredNoteByPageOperationPhase, storage, page);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(page);
		else dispatchError(op.error);
	}
}
}