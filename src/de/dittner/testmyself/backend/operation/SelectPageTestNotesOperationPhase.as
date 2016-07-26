package de.dittner.testmyself.backend.operation {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.page.TestPageInfo;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectPageTestNotesOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function SelectPageTestNotesOperationPhase(conn:SQLConnection, pageInfo:TestPageInfo, sqlFactory:SQLLib, noteClass:Class) {
		super();
		this.conn = conn;
		this.pageInfo = pageInfo;
		this.sqlFactory = sqlFactory;
		this.noteClass = noteClass;
	}

	private var conn:SQLConnection;
	private var pageInfo:TestPageInfo;
	private var sqlFactory:SQLLib;
	private var noteClass:Class;

	public function execute():void {
		var testInfo:Test = pageInfo.testSpec.info;

		var sqlParams:Object = {};
		sqlParams.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		sqlParams.amount = pageInfo.pageSize;
		sqlParams.selectedTestID = pageInfo.testSpec.info.id;
		sqlParams.onlyFailedNotes = pageInfo.onlyFailedNotes ? 1 : 0;

		var sql:String;

		var filter:NoteFilter = pageInfo.testSpec.filter;
		if (filter.selectedThemes.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
			sql = testInfo.useExamples ? SQLLib.SELECT_FILTERED_PAGE_TEST_EXAMPLES_SQL : sqlFactory.selectFilteredPageTestNotes;
			sql = sql.replace("#filterList", themes);
		}
		else {
			sql = testInfo.useExamples ? sqlFactory.selectPageTestExamples : sqlFactory.selectPageTestNotes;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		if (!testInfo.useExamples) statement.itemClass = noteClass;
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		if (pageInfo.testSpec.info.useExamples) {
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