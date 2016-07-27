package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.ui.common.page.NotePageInfo;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.getQualifiedClassName;

public class CountFilteredNoteByPageOperation extends AsyncOperation implements IAsyncCommand {

	public function CountFilteredNoteByPageOperation(storage:Storage, page:NotePageInfo) {
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:NotePageInfo;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.vocabularyID = page.vocabulary.id;

		if (page.selectedTheme) {
			var sql:String = SQLLib.SELECT_COUNT_FILTERED_NOTE_SQL;
			sqlParams.selectedThemeID = page.selectedTheme.id
		}
		else {
			sql = SQLLib.SELECT_COUNT_NOTE_SQL;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				page.allNotesAmount = countData[prop] as int;
				break;
			}
			page.countAllNotes = false;
			dispatchSuccess();
		}
		else {
			CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": Не удалось получить число записей в таблице");
			dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
		}
	}

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
		page = null;
	}
}
}
