package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.test.TestSpec;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;

public class CountTestTasksSQLOperation extends DeferredOperation {

	public function CountTestTasksSQLOperation(service:NoteService, spec:TestSpec, onlyFailedNotes:Boolean) {
		super();
		this.service = service;
		this.spec = spec;
		this.onlyFailedNotes = onlyFailedNotes;
	}

	private var service:NoteService;
	private var spec:TestSpec;
	private var onlyFailedNotes:Boolean;

	override public function process():void {
		if (spec) {
			var sqlStatement:String;
			var filter:NoteFilter = spec.filter;
			if (filter.selectedThemes.length > 0) {
				sqlStatement = spec.info.useNoteExample ? service.sqlFactory.selectCountFilteredTestExampleTask : service.sqlFactory.selectCountFilteredTestTask;
				var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
				sqlStatement = sqlStatement.replace("#filterList", themes);
			}
			else {
				sqlStatement = spec.info.useNoteExample ? service.sqlFactory.selectCountTestExampleTask : service.sqlFactory.selectCountTestTask;
			}

			var sqlParams:Object = {};
			sqlParams.selectedTestID = spec.info.id;
			sqlParams.onlyFailedNotes = onlyFailedNotes ? 1 : 0;

			service.sqlRunner.execute(sqlStatement, sqlParams, loadCompleteHandler);
		}
		else {
			dispatchCompleteWithError(new CommandException(ErrorCode.NULLABLE_TEST_SPEC, "Отсутствует спецификация к тесту, необходимая для подсчета тестовых задач"));
		}
	}

	private function loadCompleteHandler(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			var amout:uint = 0;
			for (var prop:String in countData) {
				amout = countData[prop] as int;
				break;
			}
			dispatchCompleteSuccess(new CommandResult(amout));
		}
		else {
			dispatchCompleteWithError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Не удалось получить число тестов в таблице"));
		}
	}
}
}