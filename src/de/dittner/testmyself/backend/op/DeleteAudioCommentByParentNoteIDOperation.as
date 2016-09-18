package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class DeleteAudioCommentByParentNoteIDOperation extends StorageOperation implements IAsyncCommand {

	public function DeleteAudioCommentByParentNoteIDOperation(storage:Storage, parentNoteID:int) {
		super();
		this.storage = storage;
		this.parentNoteID = parentNoteID;
	}

	private var storage:Storage;
	private var parentNoteID:int;

	public function execute():void {
		if (parentNoteID != -1) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_AUDIO_COMMENT_BY_PARENT_NOTE_ID_SQL, {parentNoteID: parentNoteID});
			statement.sqlConnection = storage.audioSqlConnection;
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