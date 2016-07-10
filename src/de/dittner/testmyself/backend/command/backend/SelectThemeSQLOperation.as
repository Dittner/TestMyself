package de.dittner.testmyself.backend.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.NoteService;
import de.dittner.testmyself.backend.command.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.theme.Theme;

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