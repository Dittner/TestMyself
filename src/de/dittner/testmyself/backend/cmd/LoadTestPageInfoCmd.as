package de.dittner.testmyself.backend.cmd {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.CountTestTasksOperation;
import de.dittner.testmyself.backend.op.SelectNotesByTestPageOperation;
import de.dittner.testmyself.backend.op.SelectPageTestTasksOperation;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.ui.view.test.testing.components.TestPageInfo;

public class LoadTestPageInfoCmd extends StorageOperation implements IAsyncCommand {

	public function LoadTestPageInfoCmd(storage:Storage, page:TestPageInfo) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:TestPageInfo;

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