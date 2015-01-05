package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.note.SQLFactory;

import flash.data.SQLResult;

public class SelectAllNotesOperationPhase extends PhaseOperation {

	public function SelectAllNotesOperationPhase(sqlRunner:SQLRunner, sqlFactory:SQLFactory, notes:Array, noteClass:Class) {
		super();
		this.sqlRunner = sqlRunner;
		this.sqlFactory = sqlFactory;
		this.notes = notes;
		this.noteClass = noteClass;
	}

	private var sqlRunner:SQLRunner;
	private var sqlFactory:SQLFactory;
	private var notes:Array;
	private var noteClass:Class;

	override public function execute():void {
		var sqlStatement:String = "SELECT * FROM note";
		var sqlParams:Object = {};
		sqlRunner.execute(sqlStatement, sqlParams, loadedHandler, noteClass);
	}

	private function loadedHandler(result:SQLResult):void {
		if (result.data is Array) {
			for (var i:int = 0; i < result.data.length; i++) {
				notes.push(result.data[i]);
			}
		}
		dispatchComplete();
	}

	override public function destroy():void {
		super.destroy();
		sqlRunner = null;
	}
}
}