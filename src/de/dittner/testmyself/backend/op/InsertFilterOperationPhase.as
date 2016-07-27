package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class InsertFilterOperationPhase extends AsyncOperation implements IAsyncCommand {
	public function InsertFilterOperationPhase(noteID:int, theme:Theme, conn:SQLConnection, sql:String) {
		this.noteID = noteID;
		this.theme = theme;
		this.conn = conn;
		this.sql = sql;
	}

	private var noteID:int;
	private var theme:Theme;
	private var conn:SQLConnection;
	private var sql:String;

	public function execute():void {
		var sqlParams:Object = theme.serialize();

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete, executeError));
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
		theme = null;
		conn = null;
		sql = null;
	}
}
}