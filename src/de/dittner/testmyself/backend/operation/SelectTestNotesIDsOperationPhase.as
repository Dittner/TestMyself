package de.dittner.testmyself.backend.operation {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.model.domain.test.Test;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectTestNotesIDsOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function SelectTestNotesIDsOperationPhase(conn:SQLConnection, testInfo:Test, sqlFactory:SQLLib, notesIDs:Array) {
		super();
		this.conn = conn;
		this.testInfo = testInfo;
		this.sqlFactory = sqlFactory;
		this.notesIDs = notesIDs;
	}

	private var conn:SQLConnection;
	private var testInfo:Test;
	private var sqlFactory:SQLLib;
	private var notesIDs:Array;

	public function execute():void {
		var sql:String = sqlFactory.selectTestNoteID;
		var sqlParams:Object = {};
		sqlParams.selectedTestID = testInfo.id;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = conn;
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
		testInfo = null;
		conn = null;
	}
}
}