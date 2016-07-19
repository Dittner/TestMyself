package de.dittner.testmyself.backend.operation {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.SQLUtils;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectNoteSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectNoteSQLOperation(service:SQLStorage, noteID:int, noteClass:Class) {
		super();
		this.service = service;
		this.noteID = noteID;
		this.noteClass = noteClass;
	}

	private var service:SQLStorage;
	private var noteID:int;
	private var noteClass:Class;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.noteID = noteID;

		var statement:SQLStatement = SQLUtils.createSQLStatement(service.sqlFactory.selectNote, sqlParams);
		statement.itemClass = noteClass;
		statement.sqlConnection = service.sqlConnection;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		var notes:Array = result.data is Array ? result.data as Array : [];
		dispatchSuccess(notes.length > 0 ? notes[0] : null);
	}
}
}