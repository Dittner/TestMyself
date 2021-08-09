package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.HashData;
import de.dittner.testmyself.backend.utils.SQLUtils;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class LoadHashDataCmd extends StorageOperation implements IAsyncCommand {

	public function LoadHashDataCmd(storage:Storage, hashDataKey:String) {
		super();
		this.storage = storage;
		this.hashDataKey = hashDataKey;
	}

	private var storage:Storage;
	private var hashDataKey:String;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.key = hashDataKey;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_HASH_DATA_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data is Array && (result.data as Array).length > 0) {
			var res:HashData = new HashData();
			res.key = hashDataKey;
			res.data = (result.data as Array)[0].data;
			res.isStored = true;
			dispatchSuccess(res);
		}
		else {
			dispatchSuccess(null);
		}
	}
}
}