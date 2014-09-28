package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.test.TestInfo;

import flash.data.SQLResult;

public class SelectTestNotesIDsOperationPhase extends PhaseOperation {

	public function SelectTestNotesIDsOperationPhase(sqlRunner:SQLRunner, testInfo:TestInfo, sqlFactory:SQLFactory, notesIDs:Array) {
		super();
		this.sqlRunner = sqlRunner;
		this.testInfo = testInfo;
		this.sqlFactory = sqlFactory;
		this.notesIDs = notesIDs;
	}

	private var sqlRunner:SQLRunner;
	private var testInfo:TestInfo;
	private var sqlFactory:SQLFactory;
	private var notesIDs:Array;

	override public function execute():void {
		var sqlStatement:String = sqlFactory.selectTestNoteID;
		var sqlParams:Object = {};
		sqlParams.selectedTestID = testInfo.id;
		sqlRunner.execute(sqlStatement, sqlParams, loadedHandler);
	}

	private function loadedHandler(result:SQLResult):void {
		if (result.data is Array) {
			for (var i:int = 0; i < result.data.length; i++) {
				notesIDs.push(result.data[i].noteID);
			}
		}
		dispatchComplete();
	}

	override public function destroy():void {
		super.destroy();
		testInfo = null;
		sqlRunner = null;
	}
}
}