package de.dittner.testmyself.backend.utils {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.model.domain.note.Note;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectAllExamplesOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function SelectAllExamplesOperationPhase(conn:SQLConnection, sqlFactory:SQLLib, examples:Array) {
		super();
		this.conn = conn;
		this.sqlFactory = sqlFactory;
		this.examples = examples;
	}

	private var conn:SQLConnection;
	private var sqlFactory:SQLLib;
	private var examples:Array;

	public function execute():void {
		var sql:String = "SELECT * FROM example";
		var sqlParams:Object = {};

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data is Array) {
			var example:Note;
			for each(var item:Object in result.data) {
				example = new Note();
				example.id = item.id;
				example.title = item.title;
				example.description = item.description;
				example.audioComment = item.audioComment;
				examples.push(example);
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