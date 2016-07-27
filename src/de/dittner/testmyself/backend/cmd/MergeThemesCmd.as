package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.*;
import de.dittner.testmyself.model.domain.theme.Theme;

public class MergeThemesCmd extends AsyncOperation implements IAsyncCommand {

	public function MergeThemesCmd(storage:Storage, destTheme:Theme, srcTheme:Theme) {
		super();
		this.storage = storage;
		this.destTheme = destTheme;
		this.srcTheme = srcTheme;
	}

	private var storage:Storage;
	private var destTheme:Theme;
	private var srcTheme:Theme;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(DeleteThemeOperation, storage, srcTheme);
		composite.addOperation(UpdateFilterOperation, storage, destTheme, srcTheme);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}

}
}