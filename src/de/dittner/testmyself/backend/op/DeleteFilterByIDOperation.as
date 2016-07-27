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

public class DeleteFilterByIDOperation extends AsyncOperation implements IAsyncCommand {

	public function DeleteFilterByIDOperation(storage:Storage, theme:Theme) {
		super();
		this.storage = storage;
		this.theme = theme;
	}

	private var storage:Storage;
	private var theme:Theme;

	public function execute():void {
		if (theme.id == -1) {
			CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.NULLABLE_NOTE + ": Отсутствует ID темы");
			dispatchError(ErrorCode.NULLABLE_NOTE);
		}
		else {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_FILTER_BY_ID_SQL, {deletingThemeID: theme.id});
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(deleteCompleteHandler, deleteFailedHandler));
		}
	}

	private function deleteCompleteHandler(result:SQLResult):void {
		dispatchSuccess();
	}

	private function deleteFailedHandler(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.NULLABLE_NOTE + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
	}
}
}