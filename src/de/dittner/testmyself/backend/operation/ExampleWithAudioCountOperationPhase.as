package de.dittner.testmyself.backend.operation {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.model.domain.note.SQLLib;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyInfo;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class ExampleWithAudioCountOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function ExampleWithAudioCountOperationPhase(conn:SQLConnection, info:VocabularyInfo, sqlFactory:SQLLib) {
		this.conn = conn;
		this.info = info;
		this.sqlFactory = sqlFactory;
	}

	private var info:VocabularyInfo;
	private var conn:SQLConnection;
	private var sqlFactory:SQLLib;

	public function execute():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(sqlFactory.selectCountExampleWithAudio);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				info.audioCommentsAmount += countData[prop] as int;
				break;
			}
			dispatchSuccess();
		}
		else {
			dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Не удалось получить число примеров с аудио в таблице"));
		}
	}

	override public function destroy():void {
		super.destroy();
		info = null;
		conn = null;
	}
}
}
