package dittner.testmyself.core.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;

import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.audioComment.AudioComment;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class ConvertDataBaseToSOSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function ConvertDataBaseToSOSQLOperation(service:NoteService, dbSOStorage:SharedObjectStorage) {
		super();
		this.service = service;
		this.dbSOStorage = dbSOStorage;
	}

	private var service:NoteService;
	private var dbSOStorage:SharedObjectStorage;
	private var data:Object = {};

	public function execute():void {
		loadFromNoteTbl();
	}

	//--------------------------------------
	//  Note
	//--------------------------------------

	private function loadFromNoteTbl():void {
		var sql:String = "SELECT * FROM note";
		var sqlParams:Object = {};

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = service.sqlConnection;
		statement.execute(-1, new Responder(notesLoaded));
	}

	private function notesLoaded(result:SQLResult):void {
		var items:Array = result.data is Array ? result.data as Array : [];
		for each(var item:Object in items) {
			if (item.audioComment is AudioComment)
				item.audioComment = (item.audioComment as AudioComment).bytes;
		}
		data["note"] = items;

		loadFromExampleTbl();
	}

	//--------------------------------------
	//  Example
	//--------------------------------------

	private function loadFromExampleTbl():void {
		var sql:String = "SELECT * FROM example";
		var sqlParams:Object = {};

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = service.sqlConnection;
		statement.execute(-1, new Responder(examplesLoaded));
	}

	private function examplesLoaded(result:SQLResult):void {
		var items:Array = result.data is Array ? result.data as Array : [];
		for each(var item:Object in items) {
			if (item.audioComment is AudioComment)
				item.audioComment = (item.audioComment as AudioComment).bytes;
		}
		data["examples"] = items;

		loadFromThemeTbl();
	}

	//--------------------------------------
	//  Theme
	//--------------------------------------

	private function loadFromThemeTbl():void {
		var sql:String = "SELECT * FROM theme";
		var sqlParams:Object = {};

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = service.sqlConnection;
		statement.execute(-1, new Responder(themesLoaded));
	}

	private function themesLoaded(result:SQLResult):void {
		var items:Array = result.data is Array ? result.data as Array : [];
		data["themes"] = items;

		loadFromFilterTbl();
	}

	//--------------------------------------
	//  Filter
	//--------------------------------------

	private function loadFromFilterTbl():void {
		var sql:String = "SELECT * FROM filter";
		var sqlParams:Object = {};

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = service.sqlConnection;
		statement.execute(-1, new Responder(filtersLoaded));
	}

	private function filtersLoaded(result:SQLResult):void {
		var items:Array = result.data is Array ? result.data as Array : [];
		data["filters"] = items;

		dbSOStorage.putObject(service.moduleName, data);
		dbSOStorage.forceFlush();
		dispatchSuccess();
	}
}
}