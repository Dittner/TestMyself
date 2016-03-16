package dittner.testmyself.core.command.backend {

import dittner.async.AsyncOperation;
import dittner.async.IAsyncCommand;
import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.deutsch.view.common.audio.mp3.MP3Writer;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.ByteArray;

public class UpdateNoteExampleSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function UpdateNoteExampleSQLOperation(service:NoteService, sute:NoteSuite) {
		this.service = service;
		this.example = sute.note;
	}

	private var service:NoteService;
	private var example:Note;

	public function execute():void {
		if (example.audioComment && example.audioComment.bytes && example.audioComment.bytes.length > 0 && !example.audioComment.isMp3) {
			try {
				MP3Writer.encodeRawData(example.audioComment.bytes, encodeCompleteHandler);
			}
			catch (error:Error) {
				dispatchError(new CommandException(ErrorCode.MP3_ENCODING_FAILED, error.message));
			}
		}
		else {
			store();
		}
	}

	private function encodeCompleteHandler(output:ByteArray):void {
		example.audioComment.isMp3 = true;
		example.audioComment.bytes.clear();
		example.audioComment.bytes = output;
		store();
	}

	private function store():void {
		var sqlParams:Object = example.toSQLData();
		sqlParams.updatingNoteID = example.id;

		var statement:SQLStatement = SQLUtils.createSQLStatement(service.sqlFactory.updateNoteExample, sqlParams);
		statement.sqlConnection = service.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

}
}