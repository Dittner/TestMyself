package de.dittner.testmyself.backend.cmd {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.SQLLib;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class StoreThemeCmd extends AsyncOperation implements IAsyncCommand {

	public function StoreThemeCmd(storage:SQLStorage, theme:Theme) {
		super();
		this.storage = storage;
		this.theme = theme;
	}

	private var storage:SQLStorage;
	private var theme:Theme;

	public function execute():void {
		if (!theme || theme.id != -1) {
			CLog.err(LogCategory.STORAGE, ErrorCode.NULLABLE_THEME + ": Отсутствует добавляемая тема");
			dispatchError(ErrorCode.NULLABLE_THEME);
			return
		}

		var sqlParams:Object = {};
		var statement:SQLStatement;

		if (theme.isNew) {
			sqlParams.name = theme.name;
			sqlParams.vocabularyID = theme.vocabularyID;
			statement = SQLUtils.createSQLStatement(SQLLib.INSERT_THEME_SQL, sqlParams);
		}
		else {
			sqlParams.themeID = theme.id;
			sqlParams.name = theme.name;
			sqlParams.vocabularyID = theme.vocabularyID;
			statement = SQLUtils.createSQLStatement(SQLLib.UPDATE_THEME_SQL, sqlParams);
		}

		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));

	}

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			theme.id = result.lastInsertRowID;
			dispatchSuccess();
		}
		else {
			CLog.err(LogCategory.STORAGE, ErrorCode.THEME_ADDED_WITHOUT_ID + ": База данных не вернула ID добавленной темы");
			dispatchError(ErrorCode.THEME_ADDED_WITHOUT_ID);
		}
	}

}
}