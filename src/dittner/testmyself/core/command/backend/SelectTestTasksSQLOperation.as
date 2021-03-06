package dittner.testmyself.core.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestSpec;
import dittner.testmyself.core.model.test.TestTask;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectTestTasksSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectTestTasksSQLOperation(service:NoteService, spec:TestSpec) {
		super();
		this.service = service;
		this.spec = spec;
	}

	private var service:NoteService;
	private var spec:TestSpec;

	public function execute():void {
		if (spec) {
			var info:TestInfo = spec.info;
			var sql:String;
			var filter:NoteFilter = spec.filter;

			var sqlParams:Object = {};
			sqlParams.selectedTestID = spec.info.id;
			sqlParams.ignoreAudio = !spec.audioRecordRequired;
			sqlParams.complexity = spec.complexity;

			if (filter.selectedThemes.length > 0) {
				sql = info.useNoteExample ? service.sqlFactory.selectFilteredTestExampleTask : service.sqlFactory.selectFilteredTestTask;
				var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
				sql = sql.replace("#filterList", themes);
			}
			else {
				sql = info.useNoteExample ? service.sqlFactory.selectTestExampleTask : service.sqlFactory.selectTestTask;
			}

			var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
			statement.sqlConnection = service.sqlConnection;
			statement.itemClass = TestTask;
			statement.execute(-1, new Responder(executeComplete));
		}
		else {
			dispatchError(new CommandException(ErrorCode.NULLABLE_TEST_SPEC, "Отсутствует спецификация к тесту, необходимая для выборки тестовых задач"));
		}
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess(result.data);
	}
}
}