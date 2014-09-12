package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;

public class SelectNoteKeysSQLOperation extends DeferredOperation {

	public function SelectNoteKeysSQLOperation(service:NoteService, sqlFactory:SQLFactory, noteClass:Class) {
		super();
		this.service = service;
		this.sqlFactory = sqlFactory;
		this.noteClass = noteClass;
	}

	private var service:NoteService;
	private var sqlFactory:SQLFactory;
	private var noteClass:Class;

	override public function process():void {
		service.sqlRunner.execute(sqlFactory.selectNoteKeys, null, loadedHandler, noteClass);
	}

	private function loadedHandler(result:SQLResult):void {
		var keys:Array = result.data is Array ? result.data as Array : [];
		dispatchCompleteSuccess(new CommandResult(keys));
	}
}
}