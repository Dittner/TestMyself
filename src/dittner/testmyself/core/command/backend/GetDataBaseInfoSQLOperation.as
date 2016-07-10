package dittner.testmyself.core.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;

import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.note.NotesInfo;
import dittner.testmyself.core.service.NoteService;

public class GetDataBaseInfoSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function GetDataBaseInfoSQLOperation(service:NoteService, filter:NoteFilter) {
		this.service = service;
		this.filter = filter;
		info = new NotesInfo();
	}

	private var service:NoteService;
	private var info:NotesInfo;
	private var filter:NoteFilter;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(NoteCountOperationPhase, service.sqlConnection, info, service.sqlFactory);
		composite.addOperation(FilteredNoteCountOperationPhase, service.sqlConnection, info, filter, service.sqlFactory);
		composite.addOperation(NoteWithAudioCountOperationPhase, service.sqlConnection, info, service.sqlFactory);
		composite.addOperation(ExampleCountOperationPhase, service.sqlConnection, info, service.sqlFactory);
		composite.addOperation(ExampleWithAudioCountOperationPhase, service.sqlConnection, info, service.sqlFactory);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(info);
		else dispatchError(op.error);
	}
}
}