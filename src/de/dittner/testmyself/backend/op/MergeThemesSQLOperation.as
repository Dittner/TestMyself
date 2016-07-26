package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;

public class MergeThemesSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function MergeThemesSQLOperation(storage:SQLStorage, destThemeID:int, srcThemeID:int) {
		super();
		this.storage = storage;
		this.destThemeID = destThemeID;
		this.srcThemeID = srcThemeID;
	}

	private var storage:SQLStorage;
	private var destThemeID:int;
	private var srcThemeID:int;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(DeleteThemeOperationPhase, storage.sqlConnection, srcThemeID);
		composite.addOperation(UpdateFilterOperationPhase, storage.sqlConnection, destThemeID, srcThemeID);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}

}
}