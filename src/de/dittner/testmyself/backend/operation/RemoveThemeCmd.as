package de.dittner.testmyself.backend.operation {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.op.DeleteThemeOperationPhase;

public class RemoveThemeCmd extends AsyncOperation implements IAsyncCommand {

	public function RemoveThemeCmd(service:SQLStorage, themeID:int) {
		super();
		this.service = service;
		this.themeID = themeID;
	}

	private var service:SQLStorage;
	private var themeID:int;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(DeleteThemeOperationPhase, service.sqlConnection, themeID);
		composite.addOperation(DeleteFilterByIDOperationPhase, service.sqlConnection, themeID);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}

}
}