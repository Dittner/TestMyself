package dittner.testmyself.core.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;

import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;

public class UpdateNoteSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function UpdateNoteSQLOperation(service:NoteService, suite:NoteSuite, testModel:TestModel) {
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
		composite.addOperation(NoteUpdateOperationPhase, service.sqlConnection, suite.note, service.sqlFactory);
		composite.addOperation(DeleteFilterByNoteIDOperationPhase, service.sqlConnection, suite.note.id, service.sqlFactory);
		composite.addOperation(DeleteTestTaskByNoteIDOperationPhase, service.sqlConnection, suite.note.id, service.sqlFactory);
		composite.addOperation(DeleteTestExampleTaskByNoteIDOperationPhase, service.sqlConnection, suite.note.id, service.sqlFactory);
		composite.addOperation(DeleteExampleByNoteIDOperationPhase, service.sqlConnection, suite.note.id, service.sqlFactory);
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