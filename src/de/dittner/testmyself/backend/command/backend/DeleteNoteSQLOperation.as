package de.dittner.testmyself.backend.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.NoteService;
import de.dittner.testmyself.model.domain.note.NoteSuite;

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