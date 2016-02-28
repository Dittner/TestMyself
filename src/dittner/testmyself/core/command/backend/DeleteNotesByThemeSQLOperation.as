package dittner.testmyself.core.command.backend {
import dittner.async.AsyncOperation;
import dittner.async.CompositeCommand;
import dittner.async.IAsyncCommand;
import dittner.async.IAsyncOperation;
import dittner.testmyself.core.service.NoteService;

public class DeleteNotesByThemeSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function DeleteNotesByThemeSQLOperation(service:NoteService, themeID:int) {
		super();
		this.service = service;
		this.themeID = themeID;
	}

	private var service:NoteService;
	private var themeID:int;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(DeleteNotesByThemeOperationPhase, service.sqlConnection, themeID, service.sqlFactory);
		composite.addOperation(DeleteThemeOperationPhase, service.sqlConnection, themeID, service.sqlFactory);
		composite.addOperation(DeleteFilterByIDOperationPhase, service.sqlConnection, themeID, service.sqlFactory);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}

}
}