package de.dittner.testmyself.backend.cmd {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.DeleteFilterByIDOperation;
import de.dittner.testmyself.backend.op.DeleteThemeOperation;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.model.domain.theme.Theme;

public class RemoveThemeCmd extends StorageOperation implements IAsyncCommand {

	public function RemoveThemeCmd(storage:Storage, theme:Theme) {
		super();
		this.storage = storage;
		this.theme = theme;
	}

	private var storage:Storage;
	private var theme:Theme;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(DeleteThemeOperation, storage, theme);
		composite.addOperation(DeleteFilterByIDOperation, storage, theme);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError();
	}

}
}