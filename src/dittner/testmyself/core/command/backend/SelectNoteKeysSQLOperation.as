package dittner.testmyself.core.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;

import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectNoteKeysSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectNoteKeysSQLOperation(service:NoteService, sqlFactory:SQLFactory, noteClass:Class) {
		super();
		this.service = service;
		this.sqlFactory = sqlFactory;
		this.noteClass = noteClass;
	}

	private var service:NoteService;
	private var sqlFactory:SQLFactory;
	private var noteClass:Class;

	public function execute():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(sqlFactory.selectNoteKeys);
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