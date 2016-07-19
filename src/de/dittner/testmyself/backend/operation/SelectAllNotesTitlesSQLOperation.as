package de.dittner.testmyself.backend.operation {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.model.domain.note.SQLLib;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectAllNotesTitlesSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectAllNotesTitlesSQLOperation(service:SQLStorage, noteClass:Class) {
		super();
		this.service = service;
		this.noteClass = noteClass;
	}

	private var service:SQLStorage;
	private var noteClass:Class;

	public function execute():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_ALL_NOTES_TITLES_SQL);
		statement.itemClass = noteClass;
		statement.sqlConnection = service.sqlConnection;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		var keys:Array = result.data is Array ? result.data as Array : [];
		dispatchSuccess(keys);
	}
}
}