package de.dittner.testmyself.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectNoteThemesOperation extends StorageOperation implements IAsyncCommand {

	public function SelectNoteThemesOperation(storage:Storage, note:Note) {
		super();
		this.storage = storage;
		this.note = note;
	}

	private var storage:Storage;
	private var note:Note;

	public function execute():void {
		if (!note || note.id == -1) {
			dispatchError(ErrorCode.NULLABLE_NOTE + ": Отсутствует запись или ID записи");
		}
		else {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_NOTE_THEMES_SQL, {
				selectedNoteID: note.id, vocabularyID: note.vocabulary.id
			});
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
	}

	private function executeComplete(result:SQLResult):void {
		var themes:Array = [];
		for each(var item:Object in result.data) {
			var theme:Theme = note.vocabulary.createTheme();
			theme.deserialize(item);
			themes.push(theme);
		}
		note.themes = themes;
		dispatchSuccess(themes);
	}
}
}