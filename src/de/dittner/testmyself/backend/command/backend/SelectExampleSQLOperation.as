package de.dittner.testmyself.backend.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.satelliteFlight.command.CommandException;
import de.dittner.testmyself.backend.NoteService;
import de.dittner.testmyself.backend.command.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.command.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;

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