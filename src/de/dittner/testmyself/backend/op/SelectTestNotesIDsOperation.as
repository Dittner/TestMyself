package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.test.Test;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectTestNotesIDsOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectTestNotesIDsOperation(storage:SQLStorage, test:Test, notesIDs:Array) {
		super();
		this.storage = storage;
		this.test = test;
		this.notesIDs = notesIDs;
	}

	private var storage:SQLStorage;
	private var test:Test;
	private var notesIDs:Array;

	public function execute():void {
		var sql:String = SQLLib.SELECT_TEST_NOTE_ID_SQL;
		var sqlParams:Object = {};
		sqlParams.selectedTestID = test.id;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data is Array) {
			for (var i:int = 0; i < result.data.length; i++) {
				notesIDs.push(result.data[i].noteID);
			}
		}
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		test = null;
		storage = null;
	}
}
}