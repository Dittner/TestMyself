package de.dittner.testmyself.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.ui.common.page.NotePageInfo;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

import mx.collections.ArrayCollection;

public class SelectNotesByPageOperation extends StorageOperation implements IAsyncCommand {

	public function SelectNotesByPageOperation(storage:Storage, page:NotePageInfo) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:NotePageInfo;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.startIndex = page.number * page.size;
		sqlParams.amount = page.size;
		sqlParams.vocabularyID = page.vocabulary.id;

		var sql:String;
		if (page.selectedTheme) {
			sqlParams.selectedThemeID = page.selectedTheme.id;
			sql = SQLLib.SELECT_FILTERED_PAGE_NOTES_SQL;
		}
		else {
			sql = SQLLib.SELECT_PAGE_NOTES_SQL;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		var notes:Array = [];
		if (result.data is Array)
			for each(var item:Object in result.data) {
				var note:Note = page.vocabulary.createNote();
				note.deserialize(item);
				notes.push(note);
			}

		page.noteColl = new ArrayCollection(notes);
		dispatchSuccess(page);
	}

}
}