package dittner.testmyself.core.command.backend {
import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.page.NotePageInfo;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectPageNotesSQLOperation extends AsyncOperation implements ICommand {

	public function SelectPageNotesSQLOperation(service:NoteService, pageInfo:NotePageInfo, noteClass:Class) {
		super();
		this.service = service;
		this.pageInfo = pageInfo;
		this.noteClass = noteClass;
	}

	private var service:NoteService;
	private var pageInfo:NotePageInfo;
	private var noteClass:Class;

	public function execute():void {
		var filter:NoteFilter = pageInfo.filter;

		var sqlParams:Object = {};
		sqlParams.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		sqlParams.amount = pageInfo.pageSize;
		sqlParams.searchFilter = filter.searchFullIdentity ? filter.searchText : "%" + filter.searchText + "%";

		var sql:String;
		if (filter.selectedThemes.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
			sql = service.sqlFactory.selectFilteredPageNotes;
			sql = sql.replace("#filterList", themes);
		}
		else {
			sql = service.sqlFactory.selectPageNotes;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.itemClass = noteClass;
		statement.sqlConnection = service.sqlConnection;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		pageInfo.notes = result.data is Array ? result.data as Array : [];
		dispatchSuccess(pageInfo);
	}
}
}