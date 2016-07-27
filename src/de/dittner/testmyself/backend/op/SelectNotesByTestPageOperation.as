package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.ui.view.test.testing.components.TestPageInfo;

public class SelectNotesByTestPageOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectNotesByTestPageOperation(storage:Storage, page:TestPageInfo) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:TestPageInfo;

	public function execute():void {
		if (page.tasks.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var task:TestTask in page.tasks)
				composite.addOperation(SelectNoteForTestTaskOperation, storage, task);

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