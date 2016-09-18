package de.dittner.testmyself.backend.utils {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.*;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;

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
	private var audioItems:Array;

	public function execute():void {
		selectAllAudios();
	}

	private function selectAllAudios():void {
		var sql:String = "SELECT * FROM audio";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		audioItems = result.data as Array || [];
		storeNextAudio();
	}

	private var curAudioItem:Object;
	private function storeNextAudio(result:SQLResult = null):void {
		if (audioItems.length > 0) {
			curAudioItem = audioItems.pop();
			storeAudio(curAudioItem.noteID, curAudioItem.parentNoteID, curAudioItem.audioComment);
		}
		else {
			dropAudioTable();
		}
	}

	private function storeAudio(noteID:int, parentNoteID:int, audioComment:AudioComment):void {
		var sql:String = SQLLib.INSERT_AUDIO_SQL;
		var sqlParams:Object = {};
		sqlParams.noteID = noteID;
		sqlParams.parentNoteID = parentNoteID;
		sqlParams.audioComment = audioComment;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.audioSqlConnection;
		statement.execute(-1, new Responder(storeNextAudio, executeError));
	}

	private function dropAudioTable():void {
		var sql:String = "DROP TABLE audio";

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
