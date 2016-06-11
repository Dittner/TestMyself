package dittner.testmyself.core.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;

import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.theme.Theme;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectThemeSQLOperation extends AsyncOperation implements IAsyncCommand {

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