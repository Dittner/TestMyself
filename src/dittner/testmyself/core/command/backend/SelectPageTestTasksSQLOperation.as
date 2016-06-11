package dittner.testmyself.core.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;

import dittner.testmyself.core.model.page.TestPageInfo;
import dittner.testmyself.core.service.NoteService;

public class SelectPageTestTasksSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectPageTestTasksSQLOperation(service:NoteService, pageInfo:TestPageInfo, noteClass:Class) {
		super();
		this.service = service;
		this.pageInfo = pageInfo;
		this.noteClass = noteClass;
	}

	private var service:NoteService;
	private var pageInfo:TestPageInfo;
	private var noteClass:Class;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(SelectPageTestTasksOperationPhase, service.sqlConnection, pageInfo, service.sqlFactory);
		composite.addOperation(SelectPageTestNotesOperationPhase, service.sqlConnection, pageInfo, service.sqlFactory, noteClass);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(pageInfo);
		else dispatchError(op.error);
	}
}
}