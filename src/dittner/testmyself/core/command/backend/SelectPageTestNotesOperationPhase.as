package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.page.TestPageInfo;
import dittner.testmyself.core.model.test.TestInfo;

import flash.data.SQLResult;

public class SelectPageTestNotesOperationPhase extends PhaseOperation {

	public function SelectPageTestNotesOperationPhase(sqlRunner:SQLRunner, pageInfo:TestPageInfo, sqlFactory:SQLFactory, noteClass:Class) {
		super();
		this.sqlRunner = sqlRunner;
		this.pageInfo = pageInfo;
		this.sqlFactory = sqlFactory;
		this.noteClass = noteClass;
	}

	private var sqlRunner:SQLRunner;
	private var pageInfo:TestPageInfo;
	private var sqlFactory:SQLFactory;
	private var noteClass:Class;

	override public function execute():void {
		var testInfo:TestInfo = pageInfo.testSpec.info;

		var params:Object = {};
		params.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		params.amount = pageInfo.pageSize;
		params.selectedTestID = pageInfo.testSpec.info.id;

		var filter:NoteFilter = pageInfo.testSpec.filter;
		if (filter.selectedThemes.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
			var statement:String = testInfo.useNoteExample ? sqlFactory.selectFilteredPageTestExamples : sqlFactory.selectFilteredPageTestNotes;
			statement = statement.replace("#filterList", themes);
			sqlRunner.execute(statement, params, loadedHandler, testInfo.useNoteExample ? null : noteClass);
		}
		else {
			sqlRunner.execute(testInfo.useNoteExample ? sqlFactory.selectPageTestExamples : sqlFactory.selectPageTestNotes, params, loadedHandler, testInfo.useNoteExample ? null : noteClass);
		}
	}

	private function loadedHandler(result:SQLResult):void {
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
			pageInfo.notes = result.data;
		}
		dispatchComplete();
	}

	override public function destroy():void {
		super.destroy();
		pageInfo = null;
		sqlRunner = null;
	}
}
}