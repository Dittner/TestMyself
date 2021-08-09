package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyInfo;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class CountAudioCommentOperation extends StorageOperation implements IAsyncCommand {

	public function CountAudioCommentOperation(storage:Storage, info:VocabularyInfo) {
		this.storage = storage;
		this.info = info;
	}

	private var info:VocabularyInfo;
	private var storage:Storage;

	public function execute():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_COUNT_AUDIO_COMMENT_SQL, {vocabularyID: info.vocabulary.id});
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
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
			dispatchError(ErrorCode.SQL_TRANSACTION_FAILED + ": Не удалось получить число записей с аудио в таблице");
		}
	}

	override public function destroy():void {
		super.destroy();
		info = null;
		storage = null;
	}
}
}
