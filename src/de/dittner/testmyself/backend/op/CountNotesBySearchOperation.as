package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.common.page.SearchPageInfo;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;
import flash.utils.getQualifiedClassName;

public class CountNotesBySearchOperation extends AsyncOperation implements IAsyncCommand {

	public function CountNotesBySearchOperation(storage:Storage, page:SearchPageInfo) {
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:SearchPageInfo;

	public function execute():void {
		var sql:String = SQLLib.SELECT_COUNT_NOTES_BY_SEARCH_SQL;
		var sqlParams:Object = {};
		sqlParams.startIndex = page.number * page.size;
		sqlParams.amount = page.size;
		sqlParams.loadExamples = page.loadExamples;
		sqlParams.searchText = page.searchText;

		var allVocabularyIDs:Array = [];
		for each(var v:Vocabulary in page.lang.vocabularyHash.getList())
			allVocabularyIDs.push(v.id);

		var allVocabulariesStr:String = SQLUtils.vocabularyIDsToSqlStr(allVocabularyIDs);
		var selectedVocabulariesStr:String = SQLUtils.vocabularyIDsToSqlStr(page.vocabularyIDs);
		sql = sql.replace("#allVocabularyList", allVocabulariesStr);
		sql = sql.replace("#selectedVocabularyList", selectedVocabulariesStr);

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
			page.countAllNotes = false;
			dispatchSuccess();
		}
		else {
			CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": Не удалось получить число записей в таблице");
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
