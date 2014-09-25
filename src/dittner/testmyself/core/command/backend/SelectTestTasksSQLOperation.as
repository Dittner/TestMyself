package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.test.TestSpec;
import dittner.testmyself.core.model.test.TestTask;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;

public class SelectTestTasksSQLOperation extends DeferredOperation {

	public function SelectTestTasksSQLOperation(service:NoteService, spec:TestSpec) {
		super();
		this.service = service;
		this.spec = spec;
	}

	private var service:NoteService;
	private var spec:TestSpec;

	override public function process():void {
		if (spec) {
			var sqlStatement:String = service.sqlFactory.selectTestTask;

			if (spec.themes.length > 0) {
				sqlStatement = service.sqlFactory.selectFilteredTestTask;
				var themes:String = SQLUtils.themesToSqlStr(spec.themes);
				sqlStatement = sqlStatement.replace("#filterList", themes);
			}
			else {
				sqlStatement = service.sqlFactory.selectTestTask;
			}

			sqlStatement = sqlStatement.replace("#priority", spec.isBalancePriority ? "balanceIndex" : "amountIndex");

			var sqlParams:Object = {};
			sqlParams.selectedTestID = spec.info.id;
			sqlParams.ignoreAudio = !spec.audioRecordRequired;

			service.sqlRunner.execute(sqlStatement, sqlParams, loadCompleteHandler, TestTask);
		}
		else {
			dispatchCompleteWithError(new CommandException(ErrorCode.NULLABLE_TEST_SPEC, "Отсутствует спецификация к тесту, необходимая для выборки тестовых задач"));
		}
	}

	private function loadCompleteHandler(result:SQLResult):void {
		dispatchCompleteSuccess(new CommandResult(result.data));
	}
}
}