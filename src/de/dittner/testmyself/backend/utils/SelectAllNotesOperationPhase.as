package de.dittner.testmyself.backend.utils {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.op.StorageOperation;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectAllNotesOperationPhase extends StorageOperation implements IAsyncCommand {

	public function SelectAllNotesOperationPhase(conn:SQLConnection, sqlFactory:SQLLib, notes:Array, noteClass:Class) {
		super();
		this.conn = conn;
		this.sqlFactory = sqlFactory;
		this.notes = notes;
		this.noteClass = noteClass;
	}

	private var conn:SQLConnection;
	private var sqlFactory:SQLLib;
	private var notes:Array;
	private var noteClass:Class;

	public function execute():void {
		var sql:String = "SELECT * FROM note";
		var sqlParams:Object = {};

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data is Array) {
			for (var i:int = 0; i < result.data.length; i++) {
				notes.push(result.data[i]);
			}
		}
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		conn = null;
	}
}
}