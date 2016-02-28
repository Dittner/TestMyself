package dittner.testmyself.core.command.backend {
import dittner.async.AsyncOperation;
import dittner.async.CompositeCommand;
import dittner.async.IAsyncCommand;
import dittner.async.IAsyncOperation;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.service.NoteService;

public class DeleteNoteSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function DeleteNoteSQLOperation(service:NoteService, suite:NoteSuite) {
		super();
		this.service = service;
		this.suite = suite;
	}

	private var service:NoteService;
	private var suite:NoteSuite;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(DeleteNoteOperationPhase, service.sqlConnection, suite.note.id, service.sqlFactory);
		composite.addOperation(DeleteFilterByNoteIDOperationPhase, service.sqlConnection, suite.note.id, service.sqlFactory);
		composite.addOperation(DeleteTestTaskByNoteIDOperationPhase, service.sqlConnection, suite.note.id, service.sqlFactory);
		composite.addOperation(DeleteTestExampleTaskByNoteIDOperationPhase, service.sqlConnection, suite.note.id, service.sqlFactory);
		composite.addOperation(DeleteExampleByNoteIDOperationPhase, service.sqlConnection, suite.note.id, service.sqlFactory);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(suite);
		else dispatchError(op.error);
	}

}
}