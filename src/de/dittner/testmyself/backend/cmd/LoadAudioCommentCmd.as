package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.op.*;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class LoadAudioCommentCmd extends StorageOperation implements IAsyncCommand {

	public function LoadAudioCommentCmd(storage:Storage, note:Note) {
		super();
		this.storage = storage;
		this.note = note;
	}

	private var storage:Storage;
	private var note:Note;

	public function execute():void {
		if (!note || note.id == -1) {
			dispatchError(ErrorCode.NULLABLE_NOTE + ": Отсутствует запись или ID записи");
		}
		else {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_AUDIO_COMMENT_SQL, {noteID: note.id});
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0)
			note.audioComment = result.data[0].audioComment;
		dispatchSuccess(note);
	}

}
}