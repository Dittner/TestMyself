package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestID;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class UpdateAudioCommentCmd extends StorageOperation implements IAsyncCommand {

	public function UpdateAudioCommentCmd(storage:Storage, noteTile:String, noteID:int, comment:AudioComment, vocabulary:Vocabulary) {
		this.storage = storage;
		this.noteTile = noteTile;
		this.comment = comment;
		this.vocabulary = vocabulary;
		this.noteID = noteID;
	}

	private var noteTile:String;
	private var storage:Storage;
	private var comment:AudioComment;
	private var vocabulary:Vocabulary;
	private var noteID:int;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.title = noteTile;
		sqlParams.audioComment = comment;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.UPDATE_AUDIO_COMMENT_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		var test:Test;
		if (comment && comment.bytes.length > 0)
			for each(test in vocabulary.availableTests)
				if (test.id == TestID.WRITE_WORD || test.id == TestID.WRITE_VERB)
					break;

		if (test) {
			var cmd:IAsyncCommand = new InsertTestTaskOperationPhase(storage, noteID, test);
			cmd.addCompleteCallback(testTaskAdded);
			cmd.execute();
		}
		else {
			dispatchSuccess();
		}
	}

	private function testTaskAdded(op:IAsyncOperation):void {
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		comment = null;
		vocabulary = null;
		storage = null;
	}
}
}
