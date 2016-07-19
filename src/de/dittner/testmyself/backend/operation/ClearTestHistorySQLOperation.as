package de.dittner.testmyself.backend.operation {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.test.Test;

public class ClearTestHistorySQLOperation extends AsyncOperation implements IAsyncCommand {

	public function ClearTestHistorySQLOperation(service:SQLStorage, testInfo:Test, testModel:TestModel) {
		this.service = service;
		this.testInfo = testInfo;
		this.testModel = testModel;
	}

	private var service:SQLStorage;
	private var testInfo:Test;
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