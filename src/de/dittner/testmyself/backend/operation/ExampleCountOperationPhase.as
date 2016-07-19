package de.dittner.testmyself.backend.operation {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.model.domain.note.NotesInfo;
import de.dittner.testmyself.model.domain.note.SQLLib;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class ExampleCountOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function ExampleCountOperationPhase(conn:SQLConnection, info:NotesInfo, sqlFactory:SQLLib) {
		this.conn = conn;
		this.info = info;
		this.sqlFactory = sqlFactory;
	}

	private var info:NotesInfo;
	private var conn:SQLConnection;
	private var sqlFactory:SQLLib;

	public function execute():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(sqlFactory.selectCountExample);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				info.examplesAmount = countData[prop] as int;
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
