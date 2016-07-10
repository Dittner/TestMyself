package de.dittner.testmyself.backend.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.NoteService;

public class MergeThemesSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function MergeThemesSQLOperation(service:NoteService, destThemeID:int, srcThemeID:int) {
		super();
		this.service = service;
		this.destThemeID = destThemeID;
		this.srcThemeID = srcThemeID;
	}

	private var service:NoteService;
	private var destThemeID:int;
	private var srcThemeID:int;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(DeleteThemeOperationPhase, service.sqlConnection, srcThemeID, service.sqlFactory);
		composite.addOperation(UpdateFilterOperationPhase, service.sqlConnection, destThemeID, srcThemeID, service.sqlFactory);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}

}
}