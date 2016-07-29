package de.dittner.testmyself.backend.cmd {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class StoreThemeCmd extends StorageOperation implements IAsyncCommand {

	public function StoreThemeCmd(storage:Storage, theme:Theme) {
		super();
		this.storage = storage;
		this.theme = theme;
	}

	private var storage:Storage;
	private var theme:Theme;

	public function execute():void {
		if (!theme || theme.id != -1) {
			dispatchError(ErrorCode.NULLABLE_THEME + ": Отсутствует добавляемая тема");
			return
		}

		var sqlParams:Object = theme.serialize();
		var statement:SQLStatement;

		if (theme.isNew) {
			statement = SQLUtils.createSQLStatement(SQLLib.INSERT_THEME_SQL, sqlParams);
		}
		else {
			sqlParams.themeID = theme.id;
			statement = SQLUtils.createSQLStatement(SQLLib.UPDATE_THEME_SQL, sqlParams);
		}

		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));

	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			theme.id = result.lastInsertRowID;
			theme.vocabulary.addTheme(theme);
			dispatchSuccess();
		}
		else {
			dispatchError(ErrorCode.THEME_ADDED_WITHOUT_ID + ": База данных не вернула ID добавленной темы");
		}
	}
}
}