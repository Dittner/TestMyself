package dittner.testmyself.core.command.backend {
import com.probertson.data.QueuedStatement;

import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class UpdateNoteExampleSQLOperation extends DeferredOperation {

	public function UpdateNoteExampleSQLOperation(service:NoteService, sute:NoteSuite) {
		this.service = service;
		this.example = sute.note;
	}

	private var service:NoteService;
	private var example:Note;

	override public function process():void {
		var sqlParams:Object = example.toSQLData();
		sqlParams.updatingNoteID = example.id;
		service.sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(service.sqlFactory.updateNoteExample, sqlParams)]), executeComplete, executeError);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchCompleteSuccess(CommandResult.OK);
	}

	private function executeError(error:SQLError):void {
		dispatchCompleteWithError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

}
}