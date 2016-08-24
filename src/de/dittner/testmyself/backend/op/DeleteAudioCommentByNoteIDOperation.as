package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class DeleteAudioCommentByNoteIDOperation extends StorageOperation implements IAsyncCommand {

	public function DeleteAudioCommentByNoteIDOperation(storage:Storage, noteID:int) {
		super();
		this.storage = storage;
		this.noteID = noteID;
	}

	private var storage:Storage;
	private var noteID:int;

	public function execute():void {
		if (noteID != -1) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_AUDIO_COMMENT_BY_NOTE_ID_SQL, {noteID: noteID});
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(deleteCompleteHandler, executeError));
		}
		else {
			dispatchError(ErrorCode.NULLABLE_NOTE + ": Отсутствует ID записи");
		}
	}

	private function deleteCompleteHandler(result:SQLResult):void {
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
	}
}
}