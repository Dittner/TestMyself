package dittner.testmyself.core.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.test.TestSpec;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class CountTestTasksSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function CountTestTasksSQLOperation(service:NoteService, spec:TestSpec, onlyFailedNotes:Boolean) {
		super();
		this.service = service;
		this.spec = spec;
		this.onlyFailedNotes = onlyFailedNotes;
	}

	private var service:NoteService;
	private var spec:TestSpec;
	private var onlyFailedNotes:Boolean;

	public function execute():void {
		if (spec) {
			var sql:String;
			var filter:NoteFilter = spec.filter;
			if (filter.selectedThemes.length > 0) {
				sql = spec.info.useNoteExample ? service.sqlFactory.selectCountFilteredTestExampleTask : service.sqlFactory.selectCountFilteredTestTask;
				var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
				sql = sql.replace("#filterList", themes);
			}
			else {
				sql = spec.info.useNoteExample ? service.sqlFactory.selectCountTestExampleTask : service.sqlFactory.selectCountTestTask;
			}

			var sqlParams:Object = {};
			sqlParams.selectedTestID = spec.info.id;
			sqlParams.onlyFailedNotes = onlyFailedNotes ? 1 : 0;

			var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
			statement.sqlConnection = service.sqlConnection;
			statement.execute(-1, new Responder(loadCompleteHandler));
		}
		else {
			dispatchError(new CommandException(ErrorCode.NULLABLE_TEST_SPEC, "Отсутствует спецификация к тесту, необходимая для подсчета тестовых задач"));
		}
	}

	private function loadCompleteHandler(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			var amount:uint = 0;
			for (var prop:String in countData) {
				amount = countData[prop] as int;
				break;
			}
			dispatchSuccess(amount);
		}
		else {
			dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Не удалось получить число тестов в таблице"));
		}
	}
}
}