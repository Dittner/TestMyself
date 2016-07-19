package de.dittner.testmyself.backend.operation {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.note.NoteFilter;
import de.dittner.testmyself.model.domain.note.NotesInfo;

public class GetDataBaseInfoSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function GetDataBaseInfoSQLOperation(service:SQLStorage, filter:NoteFilter) {
		this.service = service;
		this.filter = filter;
		info = new NotesInfo();
	}

	private var service:SQLStorage;
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