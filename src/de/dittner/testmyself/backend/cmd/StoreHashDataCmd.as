package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.HashData;
import de.dittner.testmyself.backend.utils.SQLUtils;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class StoreHashDataCmd extends StorageOperation implements IAsyncCommand {

	public function StoreHashDataCmd(storage:Storage, data:HashData) {
		this.storage = storage;
		this.data = data;
	}

	private var storage:Storage;
	private var data:HashData;

	public function execute():void {
		var sql:String = data.isStored ? SQLLib.UPDATE_HASH_DATA_SQL : SQLLib.INSERT_HASH_DATA_SQL;
		var sqlParams:Object = {};
		sqlParams.key = data.key;
		sqlParams.data = data.data;
		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			data.isStored = true;
			dispatchSuccess();
		}
		else {
			dispatchError(ErrorCode.HASH_DATA_STORED_WITH_ERROR + ": failed to store hashData with key: " + data.key);
		}

	}
}
}