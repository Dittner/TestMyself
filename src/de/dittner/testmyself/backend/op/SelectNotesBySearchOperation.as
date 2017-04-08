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
			sqlParams.langID = page.lang.id;
			sqlParams.loadExamples = page.loadExamples ? 1 : 0;
			sqlParams.searchText = "%" + page.searchText.toLowerCase() + "%";

			var selectedVocabulariesStr:String = SQLUtils.idsToSqlStr(page.vocabularyIDs);
			if (selectedVocabulariesStr)
				sql = sql.replace("#selectedVocabularyList", selectedVocabulariesStr);
			else {
				executeComplete();
				return;
			}
		}
		else {
			sql = SQLLib.SEARCH_NOTES_SQL;
			sqlParams.startIndex = page.number * page.size;
			sqlParams.amount = page.size;
			sqlParams.langID = page.lang.id;
			sqlParams.searchText = "%" + page.searchText.toLowerCase() + "%";
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult = null):void {
		var notes:Array = [];
		var vocabulary:Vocabulary;
		if (result && result.data is Array)
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

		setExamplesTo(notes);
		page.coll = new ArrayCollection(notes);
		dispatchSuccess(page);
	}

	private function setExamplesTo(notes:Array):void {
		if (notes.length > 0) {
			for each(var note:Note in notes) {
				if (storage.exampleHash[note.id]) {
					var examples:Array = [];
					var example:Note;
					for each(var exampleData:Object in storage.exampleHash[note.id]) {
						example = note.createExample();
						example.deserialize(exampleData);
						examples.push(example);
					}
					note.exampleColl = new ArrayCollection(examples);
				}
			}
		}
	}
}
}