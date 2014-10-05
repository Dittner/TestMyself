package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;

public class SelectExampleSQLOperation extends DeferredOperation {

	public function SelectExampleSQLOperation(service:NoteService, exampleID:int) {
		super();
		this.service = service;
		this.exampleID = exampleID;
	}

	private var service:NoteService;
	private var exampleID:int;

	override public function process():void {
		if (exampleID != -1) {
			service.sqlRunner.execute(service.sqlFactory.selectExampleByID, {selectedExampleID: exampleID}, loadCompleteHandler);
		}
		else {
			dispatchCompleteWithError(new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID записи"));
		}
	}

	private function loadCompleteHandler(result:SQLResult):void {
		var example:Note;
		for each(var item:Object in result.data) {
			example = new Note();
			example.id = item.id;
			example.title = item.title;
			example.description = item.description;
			example.audioComment = item.audioComment;
			break;
		}
		dispatchCompleteSuccess(new CommandResult(example));
	}
}
}