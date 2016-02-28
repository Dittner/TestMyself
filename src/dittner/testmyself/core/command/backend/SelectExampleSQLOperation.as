package dittner.testmyself.core.command.backend {
import dittner.async.AsyncOperation;
import dittner.async.IAsyncCommand;
import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectExampleSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectExampleSQLOperation(service:NoteService, exampleID:int) {
		super();
		this.service = service;
		this.exampleID = exampleID;
	}

	private var service:NoteService;
	private var exampleID:int;

	public function execute():void {
		if (exampleID != -1) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(service.sqlFactory.selectExampleByID, {selectedExampleID: exampleID});
			statement.sqlConnection = service.sqlConnection;
			statement.execute(-1, new Responder(executeComplete));
		}
		else {
			dispatchError(new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID записи"));
		}
	}

	private function executeComplete(result:SQLResult):void {
		var example:Note;
		for each(var item:Object in result.data) {
			example = new Note();
			example.id = item.id;
			example.title = item.title;
			example.description = item.description;
			example.audioComment = item.audioComment;
			break;
		}
		dispatchSuccess(example);
	}
}
}