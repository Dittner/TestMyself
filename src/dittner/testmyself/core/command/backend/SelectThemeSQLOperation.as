package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.model.theme.Theme;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;

public class SelectThemeSQLOperation extends DeferredOperation {

	public function SelectThemeSQLOperation(service:NoteService) {
		super();
		this.service = service;
	}

	private var service:NoteService;

	override public function process():void {
		service.sqlRunner.execute(service.sqlFactory.selectTheme, null, loadedHandler, Theme);
	}

	private function loadedHandler(result:SQLResult):void {
		dispatchCompleteSuccess(new CommandResult(result.data));
	}
}
}