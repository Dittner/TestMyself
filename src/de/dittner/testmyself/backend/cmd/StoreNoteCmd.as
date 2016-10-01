package de.dittner.testmyself.backend.cmd {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.DeleteAudioCommentByNoteIDOperation;
import de.dittner.testmyself.backend.op.DeleteAudioCommentByParentNoteIDOperation;
import de.dittner.testmyself.backend.op.DeleteExampleByParentIDOperation;
import de.dittner.testmyself.backend.op.DeleteTestTaskByNoteIDOperation;
import de.dittner.testmyself.backend.op.InsertAudioCommentOperation;
import de.dittner.testmyself.backend.op.InsertExampleOperation;
import de.dittner.testmyself.backend.op.InsertNoteOperation;
import de.dittner.testmyself.backend.op.InsertTestTaskOperation;
import de.dittner.testmyself.backend.op.MP3EncodingOperation;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.op.UpdateNoteOperation;
import de.dittner.testmyself.model.domain.note.Note;

public class StoreNoteCmd extends StorageOperation implements IAsyncCommand {

	public function StoreNoteCmd(storage:Storage, note:Note) {
		this.storage = storage;
		this.note = note;
	}

	private var storage:Storage;
	private var note:Note;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(MP3EncodingOperation, note.audioComment);
		if (note.isNew) {
			composite.addOperation(InsertNoteOperation, storage, note);
		}
		else {
			updateExampleCache();
			composite.addOperation(UpdateNoteOperation, storage, note);
			composite.addOperation(DeleteTestTaskByNoteIDOperation, storage, note.id);
			composite.addOperation(DeleteExampleByParentIDOperation, storage, note.id);
			composite.addOperation(DeleteAudioCommentByNoteIDOperation, storage, note.id);
			composite.addOperation(DeleteAudioCommentByParentNoteIDOperation, storage, note.id);
		}
		composite.addOperation(InsertExampleOperation, storage, note);
		composite.addOperation(InsertTestTaskOperation, storage, note);
		if (note.hasAudio)
			composite.addOperation(InsertAudioCommentOperation, storage, note, null, note.audioComment);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function updateExampleCache():void {
		if (note.isExample && storage.exampleHash[note.parentID]) {
			var examples:Array = storage.exampleHash[note.parentID];
			for (var i:int = 0; i < examples.length; i++)
				if (examples[i].id == note.id) {
					examples[i] = note.serialize();
				}
		}
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(note);
		else dispatchError();
	}
}
}