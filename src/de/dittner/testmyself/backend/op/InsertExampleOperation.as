package de.dittner.testmyself.backend.op {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.note.Note;

import mx.collections.ArrayCollection;

public class InsertExampleOperation extends StorageOperation implements IAsyncCommand {

	public function InsertExampleOperation(storage:Storage, parentNote:Note) {
		this.parentNote = parentNote;
		this.storage = storage;
		this.exampleColl = parentNote.exampleColl;
	}

	private var parentNote:Note;
	private var exampleColl:ArrayCollection;
	private var storage:Storage;

	public function execute():void {
		if (exampleColl && exampleColl.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var example:Note in exampleColl) {
				example.parentID = parentNote.id;
				if (example.hasAudio)
					composite.addOperation(MP3EncodingOperation, example.audioComment);
				composite.addOperation(InsertExampleOperationPhase, storage, example);
				if (example.hasAudio)
					composite.addOperation(InsertAudioCommentOperation, storage, example, parentNote, example.audioComment);
			}
			composite.addCompleteCallback(completeHandler);
			composite.execute();
		}
		else dispatchSuccess();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError();
	}

	override public function destroy():void {
		super.destroy();
		exampleColl = null;
		storage = null;
	}
}
}