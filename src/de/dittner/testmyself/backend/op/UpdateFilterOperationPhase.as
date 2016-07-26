package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class UpdateFilterOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function UpdateFilterOperationPhase(conn:SQLConnection, newThemeID:int, oldThemeID:int) {
		super();
		this.conn = conn;
		this.newThemeID = newThemeID;
		this.oldThemeID = oldThemeID;
	}

	private var conn:SQLConnection;
	private var newThemeID:int;
	private var oldThemeID:int;

	public function execute():void {
		if (newThemeID == -1 || oldThemeID == -1) {
			CLog.err(LogCategory.STORAGE, ErrorCode.NULLABLE_NOTE + ": Отсутствует ID темы");
			dispatchError(ErrorCode.NULLABLE_NOTE);
		}
		else {
			var sqlParams:Object = {};
			sqlParams.newThemeID = newThemeID;
			sqlParams.oldThemeID = oldThemeID;

			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.UPDATE_FILTER_SQL, sqlParams);
			statement.sqlConnection = conn;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		conn = null;
	}
}
}