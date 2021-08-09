package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.model.domain.note.Note;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class InsertAudioCommentOperation extends StorageOperation implements IAsyncCommand {

	public function InsertAudioCommentOperation(storage:Storage, note:Note, parentNote:Note, audioComment:AudioComment) {
		this.storage = storage;
		this.note = note;
		this.parentNote = parentNote;
		this.audioComment = audioComment;
	}

	private var storage:Storage;
	private var note:Note;
	private var parentNote:Note;
	private var audioComment:AudioComment;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.noteID = note.id;
		sqlParams.parentNoteID = parentNote ? parentNote.id : null;
		sqlParams.audioComment = audioComment;
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.INSERT_AUDIO_SQL, sqlParams);
		statement.sqlConnection = storage.audioSqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			dispatchSuccess();
		}
		else {
			dispatchError(ErrorCode.NOTE_ADDED_WITHOUT_ID + ": База данных не вернула ID после добавления аудиокомментария");
		}
	}

	override public function destroy():void {
		super.destroy();
		audioComment = null;
		storage = null;
	}
}
}
