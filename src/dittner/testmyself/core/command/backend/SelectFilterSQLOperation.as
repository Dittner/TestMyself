package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;

public class SelectFilterSQLOperation extends DeferredOperation {

	public function SelectFilterSQLOperation(service:NoteService, noteID:int) {
		super();
		this.service = service;
		this.noteID = noteID;
	}

	private var service:NoteService;
	private var noteID:int;

	override public function process():void {
		if (noteID != -1) {
			service.sqlRunner.execute(service.sqlFactory.selectFilter, {selectedNoteID: noteID}, loadCompleteHandler);
		}
		else {
			dispatchCompleteWithError(new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID записи"));
		}
	}

	private function loadCompleteHandler(result:SQLResult):void {
		var themesID:Array = [];
		for each(var item:Object in result.data) themesID.push(item.themeID);
		dispatchCompleteSuccess(new CommandResult(themesID));
	}
}
}