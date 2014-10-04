package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.page.TestPageInfo;

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
		var params:Object = {};
		params.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		params.amount = pageInfo.pageSize;
		params.selectedTestID = pageInfo.testSpec.info.id;

		var filter:NoteFilter = pageInfo.testSpec.filter;
		if (filter.selectedThemes.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
			var statement:String = sqlFactory.selectFilteredPageTestNotes;
			statement = statement.replace("#filterList", themes);
			sqlRunner.execute(statement, params, loadedHandler, noteClass);
		}
		else {
			sqlRunner.execute(sqlFactory.selectPageTestNotes, params, loadedHandler, noteClass);
		}
	}

	private function loadedHandler(result:SQLResult):void {
		pageInfo.notes = result.data is Array ? result.data as Array : [];
		dispatchComplete();
	}

	override public function destroy():void {
		super.destroy();
		pageInfo = null;
		sqlRunner = null;
	}
}
}