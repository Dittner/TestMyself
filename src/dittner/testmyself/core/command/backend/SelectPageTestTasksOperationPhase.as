package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.page.TestPageInfo;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestTask;

import flash.data.SQLResult;

public class SelectPageTestTasksOperationPhase extends PhaseOperation {

	public function SelectPageTestTasksOperationPhase(sqlRunner:SQLRunner, pageInfo:TestPageInfo, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.pageInfo = pageInfo;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var pageInfo:TestPageInfo;
	private var sqlFactory:SQLFactory;

	override public function execute():void {
		var testInfo:TestInfo = pageInfo.testSpec.info;

		var params:Object = {};
		params.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		params.amount = pageInfo.pageSize;
		params.selectedTestID = pageInfo.testSpec.info.id;

		var filter:NoteFilter = pageInfo.testSpec.filter;
		if (filter.selectedThemes.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
			var statement:String = testInfo.useNoteExample ? sqlFactory.selectFilteredPageTestExampleTasks : sqlFactory.selectFilteredPageTestTasks;
			statement = statement.replace("#filterList", themes);
			sqlRunner.execute(statement, params, loadedHandler, TestTask);
		}
		else {
			sqlRunner.execute(testInfo.useNoteExample ? sqlFactory.selectPageTestExampleTasks : sqlFactory.selectPageTestTasks, params, loadedHandler, TestTask);
		}
	}

	private function loadedHandler(result:SQLResult):void {
		pageInfo.tasks = result.data is Array ? result.data as Array : [];
		dispatchComplete();
	}

	override public function destroy():void {
		super.destroy();
		pageInfo = null;
		sqlRunner = null;
	}
}
}