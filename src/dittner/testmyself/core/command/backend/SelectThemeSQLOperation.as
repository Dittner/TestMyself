package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.theme.Theme;

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