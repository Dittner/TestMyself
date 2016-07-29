package de.dittner.testmyself.backend.op {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.cmd.StoreThemeCmd;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.theme.Theme;

public class InsertNewThemeOperation extends StorageOperation implements IAsyncCommand {

	public function InsertNewThemeOperation(storage:Storage, note:Note) {
		this.storage = storage;
		this.note = note;
	}

	private var storage:Storage;
	private var note:Note;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();
		if (note.themes.length > 0) {
			for each(var theme:Theme in note.themes)
				if (theme.isNew)
					composite.addOperation(StoreThemeCmd, storage, theme);
		}
		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(note);
		else dispatchError();
	}
}
}