package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyInfo;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;
import flash.utils.getQualifiedClassName;

public class CountNoteOperation extends AsyncOperation implements IAsyncCommand {

	public function CountNoteOperation(storage:Storage, info:VocabularyInfo) {
		this.storage = storage;
		this.info = info;
	}

	private var info:VocabularyInfo;
	private var storage:Storage;

	public function execute():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_COUNT_NOTE_SQL, {vocabularyID: info.vocabulary.id});
		statement.sqlConnection = storage.sqlConnection;
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
			CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": Не удалось получить число записей в таблице");
			dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
		}
	}

	override public function destroy():void {
		super.destroy();
		info = null;
		storage = null;
	}
}
}
