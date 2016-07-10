package de.dittner.testmyself.backend.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.NoteService;
import de.dittner.testmyself.model.domain.note.NoteSuite;
import de.dittner.testmyself.model.domain.test.TestModel;

public class InsertNoteSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function InsertNoteSQLOperation(service:NoteService, suite:NoteSuite, testModel:TestModel) {
		this.service = service;
		this.suite = suite;
		this.testModel = testModel;
	}

	private var service:NoteService;
	private var suite:NoteSuite;
	private var testModel:TestModel;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(MP3EncodingPhase, suite.note);
		composite.addOperation(NoteInsertOperationPhase, service.sqlConnection, suite.note, service.sqlFactory);
		composite.addOperation(ThemeInsertOperationPhase, service.sqlConnection, suite.themes, service.sqlFactory);
		composite.addOperation(FilterInsertOperationPhase, service.sqlConnection, suite.note, suite.themes, service.sqlFactory);
		composite.addOperation(ExampleInsertOperationPhase, service.sqlConnection, suite.note, suite.examples, service.sqlFactory);
		composite.addOperation(TestTaskInsertOperationPhase, service.sqlConnection, suite.note, suite.examples, testModel, service.sqlFactory);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(suite);
		else dispatchError(op.error);
	}
}
}