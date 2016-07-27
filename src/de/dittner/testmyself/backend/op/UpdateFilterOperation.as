package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.getQualifiedClassName;

public class UpdateFilterOperation extends AsyncOperation implements IAsyncCommand {

	public function UpdateFilterOperation(storage:Storage, newTheme:Theme, oldTheme:Theme) {
		super();
		this.storage = storage;
		this.newTheme = newTheme;
		this.oldTheme = oldTheme;
	}

	private var storage:Storage;
	private var newTheme:Theme;
	private var oldTheme:Theme;

	public function execute():void {
		if (newTheme.id == -1 || oldTheme.id == -1) {
			CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.NULLABLE_NOTE + ": Отсутствует ID темы");
			dispatchError(ErrorCode.NULLABLE_NOTE);
		}
		else {
			var sqlParams:Object = {};
			sqlParams.newThemeID = newTheme.id;
			sqlParams.oldThemeID = oldTheme.id;

			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.UPDATE_FILTER_SQL, sqlParams);
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
	}
}
}