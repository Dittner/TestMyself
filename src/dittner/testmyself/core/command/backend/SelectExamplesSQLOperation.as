package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;

public class SelectExamplesSQLOperation extends DeferredOperation {

	public function SelectExamplesSQLOperation(service:NoteService, noteID:int) {
		super();
		this.service = service;
		this.noteID = noteID;
	}

	private var service:NoteService;
	private var noteID:int;

	override public function process():void {
		if (noteID != -1) {
			service.sqlRunner.execute(service.sqlFactory.selectExample, {selectedNoteID: noteID}, loadCompleteHandler);
		}
		else {
			dispatchCompleteWithError(new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID записи"));
		}
	}

	private function loadCompleteHandler(result:SQLResult):void {
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
		dispatchCompleteSuccess(new CommandResult(examples));
	}
}
}