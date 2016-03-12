package dittner.testmyself.core.command.backend {
import dittner.async.AsyncOperation;
import dittner.async.IAsyncCommand;
import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class SelectFilterSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectFilterSQLOperation(service:NoteService, noteID:int) {
		super();
		this.service = service;
		this.noteID = noteID;
	}

	private var service:NoteService;
	private var noteID:int;

	public function execute():void {
		if (noteID != -1) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(service.sqlFactory.selectFilter, {selectedNoteID: noteID});
			statement.sqlConnection = service.sqlConnection;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
		else {
			dispatchError(new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID записи"));
		}
	}

	private function executeComplete(result:SQLResult):void {
		var themesID:Array = [];
		for each(var item:Object in result.data) themesID.push(item.themeID);
		dispatchSuccess(themesID);
	}

	private function executeError(error:SQLError):void {
		dispatchError(error);
	}
}
}