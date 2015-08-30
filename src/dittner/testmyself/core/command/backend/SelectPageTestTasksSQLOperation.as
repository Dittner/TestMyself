package dittner.testmyself.core.command.backend {
import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.CompositeOperation;
import dittner.testmyself.core.async.IAsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.model.page.TestPageInfo;
import dittner.testmyself.core.service.NoteService;

public class SelectPageTestTasksSQLOperation extends AsyncOperation implements ICommand {

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
		var composite:CompositeOperation = new CompositeOperation();

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