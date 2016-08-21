package de.dittner.testmyself.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.common.page.SearchPage;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

import mx.collections.ArrayCollection;

public class SelectNotesBySearchOperation extends StorageOperation implements IAsyncCommand {

	public function SelectNotesBySearchOperation(storage:Storage, page:SearchPage) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:SearchPage;

	public function execute():void {
		var isFilteredSearch:Boolean = !page.loadExamples || page.vocabularyIDs.length < page.lang.vocabularyHash.amount;
		var sql:String;
		var sqlParams:Object = {};

		if (isFilteredSearch) {
			sql = SQLLib.SEARCH_FILTERED_NOTES_SQL;
			sqlParams.startIndex = page.number * page.size;
			sqlParams.amount = page.size;
			sqlParams.loadExamples = page.loadExamples ? 1 : 0;
			sqlParams.searchText = "%" + page.searchText.toLowerCase() + "%";

			var selectedVocabulariesStr:String = SQLUtils.vocabularyIDsToSqlStr(page.vocabularyIDs);
			sql = sql.replace("#selectedVocabularyList", selectedVocabulariesStr);
		}
		else {
			sql = SQLLib.SEARCH_NOTES_SQL;
			sqlParams.startIndex = page.number * page.size;
			sqlParams.amount = page.size;
			sqlParams.searchText = "%" + page.searchText.toLowerCase() + "%";
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		var notes:Array = [];
		var vocabulary:Vocabulary;
		if (result.data is Array)
			for each(var item:Object in result.data) {
				if (!item.vocabularyID)
					dispatchError("Item returned by searching has not 'vocabularyID' prop!");
				else if (!page.lang.vocabularyHash.has(item.vocabularyID))
					dispatchError("Lang has not vocabulary with id: " + item.vocabularyID);

				vocabulary = page.lang.vocabularyHash.read(item.vocabularyID);
				var note:Note = vocabulary.createNote(item);
				note.vocabulary = vocabulary;
				note.deserialize(item);
				notes.push(note);
			}

		page.noteColl = new ArrayCollection(notes);
		dispatchSuccess(page);
	}
}
}