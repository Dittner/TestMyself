package de.dittner.testmyself.backend.operation {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.page.TestPageInfo;

public class SelectPageTestTasksSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectPageTestTasksSQLOperation(service:SQLStorage, pageInfo:TestPageInfo, noteClass:Class) {
		super();
		this.service = service;
		this.pageInfo = pageInfo;
		this.noteClass = noteClass;
	}

	private var service:SQLStorage;
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