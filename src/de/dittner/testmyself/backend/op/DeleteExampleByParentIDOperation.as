package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.getQualifiedClassName;

public class DeleteExampleByParentIDOperation extends AsyncOperation implements IAsyncCommand {

	public function DeleteExampleByParentIDOperation(storage:Storage, parentID:int) {
		super();
		this.storage = storage;
		this.parentID = parentID;
	}

	private var storage:Storage;
	private var parentID:int;

	public function execute():void {
		if (parentID != -1) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_EXAMPLE_BY_PARENT_ID_SQL, {deletingParentID: parentID});
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(deleteCompleteHandler, deleteFailedHandler));
		}
		else {
			CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.NULLABLE_NOTE + ": Отсутствует ID записи");
			dispatchError(ErrorCode.NULLABLE_NOTE);
		}
	}

	private function deleteCompleteHandler(result:SQLResult):void {
		dispatchSuccess();
	}

	private function deleteFailedHandler(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
	}
}
}