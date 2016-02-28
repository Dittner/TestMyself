package dittner.testmyself.core.command.backend {
import dittner.async.AsyncOperation;
import dittner.async.CompositeCommand;
import dittner.async.IAsyncCommand;
import dittner.async.IAsyncOperation;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;

public class ClearTestHistorySQLOperation extends AsyncOperation implements IAsyncCommand {

	public function ClearTestHistorySQLOperation(service:NoteService, testInfo:TestInfo, testModel:TestModel) {
		this.service = service;
		this.testInfo = testInfo;
		this.testModel = testModel;
	}

	private var service:NoteService;
	private var testInfo:TestInfo;
	private var testModel:TestModel;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

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