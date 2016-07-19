package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class InsertThemeOperationSubPhase extends AsyncOperation implements IAsyncCommand {
	public function InsertThemeOperationSubPhase(theme:Theme, conn:SQLConnection, sql:String) {
		this.theme = theme;
		this.conn = conn;
		this.sql = sql;
	}

	private var theme:Theme;
	private var conn:SQLConnection;
	private var sql:String;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.name = theme.name;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			theme.id = result.lastInsertRowID;
			dispatchSuccess();
		}
		else {
			dispatchError(ErrorCode.THEME_ADDED_WITHOUT_ID + ": База данных не вернула ID добавленной темы");
		}
	}

	private function executeError(error:SQLError):void {
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
	}

	override public function destroy():void {
		super.destroy();
		theme = null;
		conn = null;
		sql = null;
	}
}
}