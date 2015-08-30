package dittner.testmyself.core.command.backend {

import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.page.TestPageInfo;
import dittner.testmyself.core.model.test.TestInfo;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectPageTestNotesOperationPhase extends AsyncOperation implements ICommand {

	public function SelectPageTestNotesOperationPhase(conn:SQLConnection, pageInfo:TestPageInfo, sqlFactory:SQLFactory, noteClass:Class) {
		super();
		this.conn = conn;
		this.pageInfo = pageInfo;
		this.sqlFactory = sqlFactory;
		this.noteClass = noteClass;
	}

	private var conn:SQLConnection;
	private var pageInfo:TestPageInfo;
	private var sqlFactory:SQLFactory;
	private var noteClass:Class;

	public function execute():void {
		var testInfo:TestInfo = pageInfo.testSpec.info;

		var sqlParams:Object = {};
		sqlParams.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		sqlParams.amount = pageInfo.pageSize;
		sqlParams.selectedTestID = pageInfo.testSpec.info.id;
		sqlParams.onlyFailedNotes = pageInfo.onlyFailedNotes ? 1 : 0;

		var sql:String;

		var filter:NoteFilter = pageInfo.testSpec.filter;
		if (filter.selectedThemes.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
			sql = testInfo.useNoteExample ? sqlFactory.selectFilteredPageTestExamples : sqlFactory.selectFilteredPageTestNotes;
			sql = sql.replace("#filterList", themes);
		}
		else {
			sql = testInfo.useNoteExample ? sqlFactory.selectPageTestExamples : sqlFactory.selectPageTestNotes;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		if (!testInfo.useNoteExample) statement.itemClass = noteClass;
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		if (pageInfo.testSpec.info.useNoteExample) {
			var examples:Array = [];
			var example:Note;
			for each(var item:Object in result.data) {
				example = new Note();
				example.id = item.id;
				example.title = item.title;
				example.description = item.description;
				example.audioComment = item.audioComment;
				examples.push(example);
			}
			pageInfo.notes = examples;
		}
		else {
			pageInfo.notes = result.data || [];
		}
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		pageInfo = null;
		conn = null;
	}
}
}