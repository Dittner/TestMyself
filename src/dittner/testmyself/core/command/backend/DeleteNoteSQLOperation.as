package dittner.testmyself.core.command.backend {
import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.CompositeOperation;
import dittner.testmyself.core.async.IAsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.service.NoteService;

public class DeleteNoteSQLOperation extends AsyncOperation implements ICommand {

	public function DeleteNoteSQLOperation(service:NoteService, suite:NoteSuite) {
		super();
		this.service = service;
		this.suite = suite;
	}

	private var service:NoteService;
	private var suite:NoteSuite;

	public function execute():void {
		var composite:CompositeOperation = new CompositeOperation();

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