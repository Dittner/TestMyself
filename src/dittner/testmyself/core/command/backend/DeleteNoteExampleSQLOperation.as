package dittner.testmyself.core.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;

import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.service.NoteService;

public class DeleteNoteExampleSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function DeleteNoteExampleSQLOperation(service:NoteService, sute:NoteSuite) {
		this.service = service;
		this.example = sute.note;
	}

	private var service:NoteService;
	private var example:Note;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(DeleteTestExampleTaskByIDOperationPhase, service.sqlConnection, example.id, service.sqlFactory);
		composite.addOperation(DeleteExampleByIDOperationPhase, service.sqlConnection, example.id, service.sqlFactory);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}

}
}