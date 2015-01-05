package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.SQLFactory;

import flash.data.SQLResult;

public class SelectAllExamplesOperationPhase extends PhaseOperation {

	public function SelectAllExamplesOperationPhase(sqlRunner:SQLRunner, sqlFactory:SQLFactory, examples:Array) {
		super();
		this.sqlRunner = sqlRunner;
		this.sqlFactory = sqlFactory;
		this.examples = examples;
	}

	private var sqlRunner:SQLRunner;
	private var sqlFactory:SQLFactory;
	private var examples:Array;

	override public function execute():void {
		var sqlStatement:String = "SELECT * FROM example";
		var sqlParams:Object = {};
		sqlRunner.execute(sqlStatement, sqlParams, loadedHandler);
	}

	private function loadedHandler(result:SQLResult):void {
		if (result.data is Array) {
			var example:Note;
			for each(var item:Object in result.data) {
				example = new Note();
				example.id = item.id;
				example.title = item.title;
				example.description = item.description;
				example.audioComment = item.audioComment;
				examples.push(example);
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