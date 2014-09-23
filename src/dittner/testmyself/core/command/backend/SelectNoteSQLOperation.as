package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;

public class SelectNoteSQLOperation extends DeferredOperation {

	public function SelectNoteSQLOperation(service:NoteService, noteID:int, noteClass:Class) {
		super();
		this.service = service;
		this.noteID = noteID;
		this.noteClass = noteClass;
	}

	private var service:NoteService;
	private var noteID:int;
	private var noteClass:Class;

	override public function process():void {
		var params:Object = {};
		params.noteID = noteID;
		service.sqlRunner.execute(service.sqlFactory.selectNote, params, loadedHandler, noteClass);
	}

	private function loadedHandler(result:SQLResult):void {
		var notes:Array = result.data is Array ? result.data as Array : [];
		dispatchCompleteSuccess(new CommandResult(notes.length > 0 ? notes[0] : null));
	}
}
}