package dittner.testmyself.core.command.backend {

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class UpdateNoteExampleSQLOperation extends AsyncOperation implements ICommand {

	public function UpdateNoteExampleSQLOperation(service:NoteService, sute:NoteSuite) {
		this.service = service;
		this.example = sute.note;
	}

	private var service:NoteService;
	private var example:Note;

	public function execute():void {
		var sqlParams:Object = example.toSQLData();
		sqlParams.updatingNoteID = example.id;

		var statement:SQLStatement = SQLUtils.createSQLStatement(service.sqlFactory.updateNoteExample, sqlParams);
		statement.sqlConnection = service.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

}
}