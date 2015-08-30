package dittner.testmyself.core.command.backend {
import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.CompositeOperation;
import dittner.testmyself.core.async.IAsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.service.NoteService;

public class MergeThemesSQLOperation extends AsyncOperation implements ICommand {

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
		var composite:CompositeOperation = new CompositeOperation();

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