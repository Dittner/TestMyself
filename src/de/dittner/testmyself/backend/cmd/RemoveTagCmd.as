package de.dittner.testmyself.backend.cmd {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.DeleteTagOperation;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.op.UpdateNotesTagsOperation;
import de.dittner.testmyself.model.domain.tag.Tag;

public class RemoveTagCmd extends StorageOperation implements IAsyncCommand {

	public function RemoveTagCmd(storage:Storage, tag:Tag) {
		super();
		this.storage = storage;
		this.tag = tag;
	}

	private var storage:Storage;
	private var tag:Tag;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(DeleteTagOperation, storage, tag);
		composite.addOperation(UpdateNotesTagsOperation, storage, tag);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError();
	}

}
}