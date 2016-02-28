package dittner.testmyself.core.command.backend {

import dittner.async.AsyncOperation;
import dittner.async.IAsyncCommand;
import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.theme.Theme;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class FilterInsertOperationSubPhase extends AsyncOperation implements IAsyncCommand {
	public function FilterInsertOperationSubPhase(noteID:int, theme:Theme, conn:SQLConnection, sql:String) {
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
		var sqlParams:Object = {};
		sqlParams.noteID = noteID;
		sqlParams.themeID = theme.id;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

	override public function destroy():void {
		super.destroy();
		theme = null;
		conn = null;
		sql = null;
	}
}
}