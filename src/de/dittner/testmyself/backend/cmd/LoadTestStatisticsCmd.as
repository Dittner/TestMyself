package de.dittner.testmyself.backend.cmd {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.CountTestTasksOperation;
import de.dittner.testmyself.backend.op.SelectNotesByTestPageOperation;
import de.dittner.testmyself.backend.op.SelectPageTestTasksOperation;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.ui.common.page.TestPage;

public class LoadTestStatisticsCmd extends StorageOperation implements IAsyncCommand {
	public function LoadTestStatisticsCmd(storage:Storage, page:TestPage) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:TestPage;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(SelectPageTestTasksOperation, storage, page);
		composite.addOperation(SelectNotesByTestPageOperation, storage, page);
		if (page.countAllNotes)
			composite.addOperation(CountTestTasksOperation, storage, page);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(page);
		else dispatchError();
	}
}
}