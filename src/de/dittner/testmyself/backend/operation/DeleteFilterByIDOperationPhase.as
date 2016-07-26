package de.dittner.testmyself.backend.operation {

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

public class DeleteFilterByIDOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function DeleteFilterByIDOperationPhase(conn:SQLConnection, themeID:int) {
		super();
		this.conn = conn;
		this.themeID = themeID;
	}

	private var conn:SQLConnection;
	private var themeID:int;

	public function execute():void {
		if (themeID == -1) {
			CLog.err(LogCategory.STORAGE, ErrorCode.NULLABLE_NOTE + ": Отсутствует ID темы");
			dispatchError(ErrorCode.NULLABLE_NOTE);
		}
		else {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_FILTER_BY_ID_SQL, {deletingThemeID: themeID});
			statement.sqlConnection = conn;
			statement.execute(-1, new Responder(deleteCompleteHandler, deleteFailedHandler));
		}
	}

	private function deleteCompleteHandler(result:SQLResult):void {
		dispatchSuccess();
	}

	private function deleteFailedHandler(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, ErrorCode.NULLABLE_NOTE + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		conn = null;
	}
}
}