package dittner.testmyself.core.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectExamplesSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectExamplesSQLOperation(service:NoteService, noteID:int) {
		super();
		this.service = service;
		this.noteID = noteID;
	}

	private var service:NoteService;
	private var noteID:int;

	public function execute():void {
		if (noteID == -1) {
			dispatchError(new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID записи"));
		}
		else {
			var statement:SQLStatement = SQLUtils.createSQLStatement(service.sqlFactory.selectExample, {selectedNoteID: noteID});
			statement.sqlConnection = service.sqlConnection;
			statement.execute(-1, new Responder(executeComplete));
		}
	}

	private function executeComplete(result:SQLResult):void {
		var examples:Array = [];
		var example:Note;
		for each(var item:Object in result.data) {
			example = new Note();
			example.id = item.id;
			example.title = item.title;
			example.description = item.description;
			example.audioComment = item.audioComment;
			examples.push(example);
		}
		dispatchSuccess(examples);
	}
}
}