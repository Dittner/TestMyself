package de.dittner.testmyself.backend.operation {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class DeleteExampleByIDOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function DeleteExampleByIDOperationPhase(conn:SQLConnection, exampleID:int, sqlFactory:SQLLib) {
		super();
		this.conn = conn;
		this.exampleID = exampleID;
		this.sqlFactory = sqlFactory;
	}

	private var conn:SQLConnection;
	private var exampleID:int;
	private var sqlFactory:SQLLib;

	public function execute():void {
		if (exampleID) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(sqlFactory.deleteExampleByID, {deletingID: exampleID});
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