package de.dittner.testmyself.backend.utils {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.*;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class RemoveDeutschDictionaryCmd extends StorageOperation implements IAsyncCommand {

	public function RemoveDeutschDictionaryCmd(storage:Storage) {
		super();
		this.storage = storage;
	}

	private var storage:Storage;

	public function execute():void {
		loadAllDeutschNoteIDs();
	}

	private function loadAllDeutschNoteIDs():void {
		var sql:String = "SELECT id FROM note WHERE langID = 1";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private var noteIDsToRemove:Array = [];
	private function executeComplete(result:SQLResult):void {
		for each(var obj:Object in result.data) {
			if (obj.id)
				noteIDsToRemove.push(obj.id);
		}
		removeNextNote();
	}

	private var curNoteID:int;
	private function removeNextNote(result:* = null):void {
		if (noteIDsToRemove.length > 0) {
			curNoteID = noteIDsToRemove.pop();
			//storage.removeNoteByID(curNoteID).addCompleteCallback(removeNoteComplete);
			removeAudioComment(curNoteID);
		}
		else {
			dispatchSuccess()
		}
	}

	private function removeAudioComment(noteID:int):void {
		var sql:String = "DELETE FROM audio WHERE noteID = " + noteID;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.audioSqlConnection;
		statement.execute(-1, new Responder(func, executeError));
	}

	private function removeTests(noteID:int):void {
		var sql:String = "DELETE FROM testTask WHERE noteID = " + noteID;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(func, executeError));
	}

	private var processedNotes:Number = 0;
	private function func(result:* = null):void {
		processedNotes++;
		if (processedNotes % 100 == 0)
			trace("processedNotes = " + processedNotes);

		removeNextNote();
	}

}
}
