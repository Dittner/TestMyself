package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class DeleteExampleByParentIDOperation extends StorageOperation implements IAsyncCommand {

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
			statement.execute(-1, new Responder(deleteCompleteHandler, executeError));
		}
		else {
			dispatchError(ErrorCode.NULLABLE_NOTE + ": Отсутствует ID записи");
		}
	}

	private function deleteCompleteHandler(result:SQLResult):void {
		delete storage.exampleHash[parentID];
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
	}
}
}