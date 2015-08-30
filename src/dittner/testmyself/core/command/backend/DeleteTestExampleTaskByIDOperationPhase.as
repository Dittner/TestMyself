package dittner.testmyself.core.command.backend {

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.SQLFactory;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class DeleteTestExampleTaskByIDOperationPhase extends AsyncOperation implements ICommand {

	public function DeleteTestExampleTaskByIDOperationPhase(conn:SQLConnection, exampleID:int, sqlFactory:SQLFactory) {
		super();
		this.conn = conn;
		this.exampleID = exampleID;
		this.sqlFactory = sqlFactory;
	}

	private var conn:SQLConnection;
	private var exampleID:int;
	private var sqlFactory:SQLFactory;

	public function execute():void {
		if (exampleID != -1) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(sqlFactory.deleteTestExampleTaskByID, {deletingNoteID: exampleID});
			statement.sqlConnection = conn;
			statement.execute(-1, new Responder(deleteCompleteHandler, deleteFailedHandler));
		}
		else dispatchError(new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID записи"));
	}

	private function deleteCompleteHandler(result:SQLResult):void {
		dispatchSuccess();
	}

	private function deleteFailedHandler(error:SQLError):void {
		dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

	override public function destroy():void {
		super.destroy();
		conn = null;
	}
}
}