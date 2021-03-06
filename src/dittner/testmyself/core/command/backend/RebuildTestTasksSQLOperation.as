package dittner.testmyself.core.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;

import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;

public class RebuildTestTasksSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function RebuildTestTasksSQLOperation(service:NoteService, testModel:TestModel, noteClass:Class) {
		this.service = service;
		this.testModel = testModel;
		this.noteClass = noteClass;
	}

	private var service:NoteService;
	private var testModel:TestModel;
	private var noteClass:Class;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();
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