package de.dittner.testmyself.backend.operation {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.NoteSuite;
import de.dittner.testmyself.ui.common.audio.mp3.MP3Writer;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.ByteArray;

public class UpdateNoteExampleSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function UpdateNoteExampleSQLOperation(service:SQLStorage, sute:NoteSuite) {
		this.service = service;
		this.example = sute.note;
	}

	private var service:SQLStorage;
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