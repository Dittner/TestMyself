package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLConnection;

public class InsertNewThemeOperation extends AsyncOperation implements IAsyncCommand {

	public function InsertNewThemeOperation(conn:SQLConnection, note:Note) {
		this.note = note;
	}

	private var note:Note;

	public function execute():void {
		if (note.themes.length > 0) {
			for each(var theme:Theme in note.themes)
				if (theme.isNew)
					theme.store();
		}

		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		note = null;
	}
}
}