package de.dittner.testmyself.backend.operation {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.SQLLib;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyInfo;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class ExampleCountOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function ExampleCountOperationPhase(conn:SQLConnection, info:VocabularyInfo) {
		this.conn = conn;
		this.info = info;
	}

	private var info:VocabularyInfo;
	private var conn:SQLConnection;

	public function execute():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_COUNT_EXAMPLE_SQL, {vocabularyID: info.vocabulary.id});
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
			CLog.err(LogCategory.STORAGE, ErrorCode.SQL_TRANSACTION_FAILED + ": Не удалось получить число записей в таблице");
			dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
		}
	}

	override public function destroy():void {
		super.destroy();
		info = null;
		conn = null;
	}
}
}
