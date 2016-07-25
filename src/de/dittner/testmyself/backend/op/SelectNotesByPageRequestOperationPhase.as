package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.NoteFilter;
import de.dittner.testmyself.model.domain.note.SQLLib;
import de.dittner.testmyself.model.page.NotePageRequest;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectNotesByPageRequestOperationPhase extends AsyncOperation {

	public function SelectNotesByPageRequestOperationPhase(storage:SQLStorage, pageRequest:NotePageRequest) {
		super();
		this.storage = storage;
		this.pageRequest = pageRequest;
	}

	private var storage:SQLStorage;
	private var pageRequest:NotePageRequest;

	public function execute():void {
		var filter:NoteFilter = pageRequest.filter;

		var sqlParams:Object = {};
		sqlParams.startIndex = pageRequest.pageNum * pageRequest.pageSize;
		sqlParams.amount = pageRequest.pageSize;
		sqlParams.searchFilter = filter.searchFullIdentity ? filter.searchText : "%" + filter.searchText + "%";

		var sql:String;
		if (filter.selectedThemes.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
			sql = SQLLib.SELECT_FILTERED_PAGE_NOTES_SQL;
			sql = sql.replace("#filterList", themes);
		}
		else {
			sql = SQLLib.SELECT_PAGE_NOTES_SQL;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		var notes:Array = [];
		if (result.data is Array)
			for each(var item:Object in result.data) {
				var note:Note = pageRequest.vocabulary.createNote();
				note.deserialize(item);
				notes.push(note);
			}

		pageRequest.notes = notes;
		dispatchSuccess(pageRequest);
	}
}
}