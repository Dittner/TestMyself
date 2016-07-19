package de.dittner.testmyself.backend.operation {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.op.InsertExampleOperationPhase;
import de.dittner.testmyself.backend.op.InsertFilterOperationPhase;
import de.dittner.testmyself.backend.op.InsertNoteOperationPhase;
import de.dittner.testmyself.backend.op.InsertTestTaskOperationPhase;
import de.dittner.testmyself.backend.op.InsertThemeOperationPhase;
import de.dittner.testmyself.backend.op.MP3EncodingOperationPhase;
import de.dittner.testmyself.model.domain.note.NoteSuite;

public class InsertNoteSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function InsertNoteSQLOperation(service:SQLStorage, suite:NoteSuite, testModel:TestModel) {
		this.service = service;
		this.suite = suite;
		this.testModel = testModel;
	}

	private var service:SQLStorage;
	private var suite:NoteSuite;
	private var testModel:TestModel;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(MP3EncodingOperationPhase, suite.note);
		composite.addOperation(InsertNoteOperationPhase, service.sqlConnection, suite.note, service.sqlFactory);
		composite.addOperation(InsertThemeOperationPhase, service.sqlConnection, suite.themes, service.sqlFactory);
		composite.addOperation(InsertFilterOperationPhase, service.sqlConnection, suite.note, suite.themes, service.sqlFactory);
		composite.addOperation(InsertExampleOperationPhase, service.sqlConnection, suite.note, suite.examples, service.sqlFactory);
		composite.addOperation(InsertTestTaskOperationPhase, service.sqlConnection, suite.note, suite.examples, testModel, service.sqlFactory);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(suite);
		else dispatchError(op.error);
	}
}
}