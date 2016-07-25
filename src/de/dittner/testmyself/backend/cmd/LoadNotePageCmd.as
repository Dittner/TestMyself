package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.op.SelectExamplesByPageRequestSQLOperation;
import de.dittner.testmyself.backend.op.SelectNotesByPageRequestOperationPhase;
import de.dittner.testmyself.backend.op.SelectThemesByPageRequestSQLOperation;
import de.dittner.testmyself.model.page.NotePageRequest;

public class LoadNotePageCmd extends AsyncOperation implements IAsyncCommand {

	public function LoadNotePageCmd(storage:SQLStorage, pageRequest:NotePageRequest) {
		super();
		this.storage = storage;
		this.pageRequest = pageRequest;
	}

	private var storage:SQLStorage;
	private var pageRequest:NotePageRequest;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(SelectNotesByPageRequestOperationPhase, storage, pageRequest);
		composite.addOperation(SelectExamplesByPageRequestSQLOperation, storage, pageRequest);
		composite.addOperation(SelectThemesByPageRequestSQLOperation, storage, pageRequest);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(pageRequest);
		else dispatchError(op.error);
	}
}
}