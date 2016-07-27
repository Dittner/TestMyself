package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.common.page.SearchPageInfo;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.getQualifiedClassName;

import mx.collections.ArrayCollection;

public class SelectNotesBySearchOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectNotesBySearchOperation(storage:Storage, page:SearchPageInfo) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:SearchPageInfo;

	public function execute():void {
		var sql:String = SQLLib.SEARCH_NOTES_SQL;
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
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		var notes:Array = [];
		var vocabulary:Vocabulary;
		if (result.data is Array)
			for each(var item:Object in result.data) {
				if (!item.vocabularyID) {
					CLog.err(LogCategory.STORAGE, "Item returned by searching has not 'vocabularyID' prop!");
					dispatchError();
				}
				else if (!page.lang.vocabularyHash.has(item.vocabularyID)) {
					CLog.err(LogCategory.STORAGE, "Lang has not vocabulary with id: " + item.vocabularyID);
					dispatchError();
				}

				vocabulary = page.lang.vocabularyHash.read(item.vocabularyID);
				var note:Note = vocabulary.createNote();
				note.deserialize(item);
				notes.push(note);
			}

		page.noteColl = new ArrayCollection(notes);
		dispatchSuccess(page);
	}

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}
}
}