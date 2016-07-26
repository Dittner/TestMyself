package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.ui.common.page.NotePageInfo;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class CountFilteredNoteByPageOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function CountFilteredNoteByPageOperationPhase(storage:SQLStorage, page:NotePageInfo) {
		this.storage = storage;
		this.page = page;
	}

	private var storage:SQLStorage;
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
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				page.allNotesAmount = countData[prop] as int;
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
		storage = null;
		page = null;
	}
}
}
