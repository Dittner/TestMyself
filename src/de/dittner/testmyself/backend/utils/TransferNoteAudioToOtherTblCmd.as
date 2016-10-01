package de.dittner.testmyself.backend.utils {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.*;
import de.dittner.testmyself.model.domain.tag.Tag;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.events.SQLEvent;
import flash.net.Responder;

public class TransferNoteAudioToOtherTblCmd extends StorageOperation implements IAsyncCommand {

	public function TransferNoteAudioToOtherTblCmd(storage:Storage) {
		super();
		this.storage = storage;
	}

	private var storage:Storage;

	public function execute():void {
		selectAllNotes();
	}

	private function renameTable():void {
		var sql:String = "ALTER TABLE theme RENAME TO tag";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(tableRenamedComplete, executeError));
	}

	private function tableRenamedComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function addColumn():void {
		var sql:String = "ALTER TABLE note ADD COLUMN tags String";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(addColumnComplete, executeError));
	}

	private function addColumnComplete(result:SQLResult):void {
		selectAllNotes();
	}

	private function selectAllNotes():void {
		var sql:String = "SELECT id,tags FROM note";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private var noteIDsToUpdate:Array = [];
	private function executeComplete(result:SQLResult):void {
		for each(var obj:Object in result.data) {
			if (obj.tags)
				noteIDsToUpdate.push(obj);
		}
		storeNextNote();
	}

	private var curNote:Object;
	private function storeNextNote(result:SQLResult = null):void {
		if (noteIDsToUpdate.length > 0) {
			curNote = noteIDsToUpdate.pop();
			storeNote(curNote.id, curNote.tags);
		}
		else {
			dispatchSuccess()
		}
	}

	private function storeNote(noteID:int, tags:String):void {
		var sql:String = "UPDATE note SET tags = :tags WHERE id = :noteID";
		var sqlParams:Object = {};
		sqlParams.noteID = noteID;
		sqlParams.tags = Tag.DELIMITER + tags;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(storeNextNote, executeError));
	}

	private function dropFilterTable():void {
		var sql:String = "DROP TABLE filter";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(dtopTblComplete, executeError));
	}

	private function dtopTblComplete(result:SQLResult):void {
		compactDB();
	}

	private function compactDB():void {
		storage.sqlConnection.compact(new Responder(compactComplete, executeError));
	}

	private function compactComplete(event:SQLEvent):void {
		dispatchSuccess();
	}

}
}
