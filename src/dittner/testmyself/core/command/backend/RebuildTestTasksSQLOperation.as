package dittner.testmyself.core.command.backend {
import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.CompositeOperation;
import dittner.testmyself.core.async.IAsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;

public class RebuildTestTasksSQLOperation extends AsyncOperation implements ICommand {

	public function RebuildTestTasksSQLOperation(service:NoteService, testModel:TestModel, noteClass:Class) {
		this.service = service;
		this.testModel = testModel;
		this.noteClass = noteClass;
	}

	private var service:NoteService;
	private var testModel:TestModel;
	private var noteClass:Class;

	public function execute():void {
		var composite:CompositeOperation = new CompositeOperation();
		var notes:Array = [];
		var examples:Array = [];
		composite.addOperation(RecreateTestTablesOperationPhase, service.sqlConnection, service.sqlFactory);
		composite.addOperation(SelectAllNotesOperationPhase, service.sqlConnection, service.sqlFactory, notes, noteClass);
		composite.addOperation(AllTestTaskInsertOperationPhase, service.sqlConnection, notes, testModel, service.sqlFactory, false);
		composite.addOperation(SelectAllExamplesOperationPhase, service.sqlConnection, service.sqlFactory, examples);
		composite.addOperation(AllTestTaskInsertOperationPhase, service.sqlConnection, examples, testModel, service.sqlFactory, true);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}
}
}