package dittner.testmyself.core.command.backend {
import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.theme.Theme;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectThemeSQLOperation extends AsyncOperation implements ICommand {

	public function SelectThemeSQLOperation(service:NoteService) {
		super();
		this.service = service;
	}

	private var service:NoteService;

	public function execute():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(service.sqlFactory.selectTheme);
		statement.sqlConnection = service.sqlConnection;
		statement.itemClass = Theme;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess(result.data);
	}
}
}