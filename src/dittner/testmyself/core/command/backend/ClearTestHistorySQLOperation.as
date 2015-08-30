package dittner.testmyself.core.command.backend {
import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.CompositeOperation;
import dittner.testmyself.core.async.IAsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;

public class ClearTestHistorySQLOperation extends AsyncOperation implements ICommand {

	public function ClearTestHistorySQLOperation(service:NoteService, testInfo:TestInfo, testModel:TestModel) {
		this.service = service;
		this.testInfo = testInfo;
		this.testModel = testModel;
	}

	private var service:NoteService;
	private var testInfo:TestInfo;
	private var testModel:TestModel;

	public function execute():void {
		var composite:CompositeOperation = new CompositeOperation();

		var notesIDs:Array = [];
		composite.addOperation(SelectTestNotesIDsOperationPhase, service.sqlConnection, testInfo, service.sqlFactory, notesIDs);
		composite.addOperation(ClearTestHistoryOperationPhase, service.sqlConnection, testInfo, notesIDs, testModel, service.sqlFactory);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}
}
}