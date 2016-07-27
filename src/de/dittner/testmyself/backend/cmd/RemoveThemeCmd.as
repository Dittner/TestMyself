package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.op.DeleteFilterByIDOperation;
import de.dittner.testmyself.backend.op.DeleteThemeOperation;

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

		composite.addOperation(DeleteThemeOperation, service.sqlConnection, themeID);
		composite.addOperation(DeleteFilterByIDOperation, service.sqlConnection, themeID);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}

}
}