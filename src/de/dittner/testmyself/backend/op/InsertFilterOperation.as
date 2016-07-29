package de.dittner.testmyself.backend.op {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.theme.Theme;

public class InsertFilterOperation extends StorageOperation implements IAsyncCommand {

	public function InsertFilterOperation(storage:Storage, note:Note) {
		this.storage = storage;
		this.note = note;
	}

	private var note:Note;
	private var storage:Storage;

	public function execute():void {
		if (note.themes.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var theme:Theme in note.themes)
				composite.addOperation(InsertFilterOperationPhase, storage, note, theme);

			composite.addCompleteCallback(completeHandler);
			composite.execute();
		}
		else dispatchSuccess();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError();
	}
}
}
