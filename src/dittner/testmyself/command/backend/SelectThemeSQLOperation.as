package dittner.testmyself.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.model.theme.Theme;

import flash.data.SQLResult;

public class SelectThemeSQLOperation extends DeferredOperation {

	public function SelectThemeSQLOperation(sqlRunner:SQLRunner, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.sqlFactory = sqlFactory;
	}

	private var sqlFactory:SQLFactory;
	private var sqlRunner:SQLRunner;

	override public function process():void {
		sqlRunner.execute(sqlFactory.selectTheme, null, loadedHandler, Theme);
	}

	private function loadedHandler(result:SQLResult):void {
		dispatchCompleteSuccess(new CommandResult(result.data));
	}
}
}