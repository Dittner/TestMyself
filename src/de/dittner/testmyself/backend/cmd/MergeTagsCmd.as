package de.dittner.testmyself.backend.cmd {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.*;
import de.dittner.testmyself.model.domain.tag.Tag;

public class MergeTagsCmd extends StorageOperation implements IAsyncCommand {

	public function MergeTagsCmd(storage:Storage, srcTag:Tag, destTag:Tag) {
		super();
		this.storage = storage;
		this.destTag = destTag;
		this.srcTag = srcTag;
	}

	private var storage:Storage;
	private var destTag:Tag;
	private var srcTag:Tag;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(DeleteTagOperation, storage, srcTag);
		composite.addOperation(UpdateNotesTagsOperation, storage, srcTag, destTag);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError();
	}

}
}