package dittner.testmyself.core.command.backend {

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.NotesInfo;
import dittner.testmyself.core.model.note.SQLFactory;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class NoteCountOperationPhase extends AsyncOperation implements ICommand {

	public function NoteCountOperationPhase(conn:SQLConnection, info:NotesInfo, sqlFactory:SQLFactory) {
		this.conn = conn;
		this.info = info;
		this.sqlFactory = sqlFactory;
	}

	private var info:NotesInfo;
	private var conn:SQLConnection;
	private var sqlFactory:SQLFactory;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.searchFilter = "%%";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sqlFactory.selectCountNote, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				info.notesAmount = countData[prop] as int;
				break;
			}
			dispatchSuccess();
		}
		else {
			dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Не удалось получить число записей в таблице"));
		}
	}

	override public function destroy():void {
		super.destroy();
		info = null;
		conn = null;
	}
}
}
