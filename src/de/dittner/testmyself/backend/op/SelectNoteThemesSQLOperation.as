package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class SelectNoteThemesSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectNoteThemesSQLOperation(service:SQLStorage, note:Note) {
		super();
		this.service = service;
		this.note = note;
	}

	private var service:SQLStorage;
	private var note:Note;

	public function execute():void {
		if (!note || note.id == -1) {
			CLog.err(LogCategory.STORAGE, ErrorCode.NULLABLE_NOTE + ": Отсутствует запись или ID записи");
			dispatchError(ErrorCode.NULLABLE_NOTE);
		}
		else {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_NOTE_THEMES_SQL, {
				selectedNoteID: note.id, vocabularyID: note.vocabulary.id
			});
			statement.sqlConnection = service.sqlConnection;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
	}

	private function executeComplete(result:SQLResult):void {
		var themes:Vector.<Theme> = new <Theme>[];
		for each(var item:Object in result.data) {
			var theme:Theme = note.vocabulary.createTheme();
			theme.deserialize(item);
			themes.push(theme);
		}
		note.themes = themes;
		dispatchSuccess(themes);
	}

	private function executeError(error:SQLError):void {
		dispatchError(error);
	}
}
}