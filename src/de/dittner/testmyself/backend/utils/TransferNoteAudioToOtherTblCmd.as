package de.dittner.testmyself.backend.utils {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.*;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class TransferNoteAudioToOtherTblCmd extends StorageOperation implements IAsyncCommand {

	public function TransferNoteAudioToOtherTblCmd(storage:Storage) {
		super();
		this.storage = storage;
	}

	private var storage:Storage;
	private var noteItems:Array;

	public function execute():void {
		addColumn();
	}

	private function addColumn():void {
		var sql:String = "ALTER TABLE note ADD COLUMN hasAudio int NOT NULL DEFAULT 0";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(columnAdded, executeError));
	}

	private function columnAdded(result:SQLResult):void {
		selectAllNotes();
	}

	private function selectAllNotes():void {
		var sql:String = "SELECT * FROM note";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		noteItems = result.data as Array || [];
		changeNextNote();
	}

	private var curNoteItem:Object;
	private function changeNextNote(result:SQLResult = null):void {
		if (noteItems.length > 0) {
			curNoteItem = noteItems.pop();
			if (curNoteItem.audioComment && (curNoteItem.audioComment as AudioComment).bytes.length > 0)
				storeAudio(curNoteItem.id, curNoteItem.audioComment);
			else
				changeNextNote();
		}
		else {
			dispatchSuccess();
		}
	}

	private function storeAudio(noteID:int, audioComment:AudioComment):void {
		var sql:String = SQLLib.INSERT_AUDIO_SQL;
		var sqlParams:Object = {};
		sqlParams.noteID = noteID;
		sqlParams.audioComment = audioComment;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(audioAdded, executeError));
	}

	private function audioAdded(result:SQLResult):void {
		updateNote(curNoteItem.id);
	}

	private function updateNote(noteID:int):void {
		var sql:String = "UPDATE note SET hasAudio = 1, audioComment = :audioComment WHERE id = :noteID";
		var sqlParams:Object = {};
		sqlParams.noteID = noteID;
		sqlParams.audioComment = null;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(changeNextNote, executeError));
	}

}
}
