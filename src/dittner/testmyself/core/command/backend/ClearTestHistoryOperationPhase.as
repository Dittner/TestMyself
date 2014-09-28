package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;

public class ClearTestHistoryOperationPhase extends PhaseOperation {

	public function ClearTestHistoryOperationPhase(sqlRunner:SQLRunner, testInfo:TestInfo, noteIDs:Array, testModel:TestModel, sqlFactory:SQLFactory) {
		this.noteIDs = noteIDs;
		this.sqlRunner = sqlRunner;
		this.testModel = testModel;
		this.testInfo = testInfo;
		this.sqlFactory = sqlFactory;
	}

	private var noteIDs:Array;
	private var testModel:TestModel;
	private var testInfo:TestInfo;
	private var sqlRunner:SQLRunner;
	private var sqlFactory:SQLFactory;
	private var subPhaseRunner:PhaseRunner;

	override public function execute():void {
		if (noteIDs.length > 0) {
			subPhaseRunner = new PhaseRunner();
			subPhaseRunner.completeCallback = dispatchComplete;

			for each(var noteID:int in noteIDs) {
				subPhaseRunner.addPhase(ClearTestHistoryOperationSubPhase, testInfo.id, noteID, sqlRunner, sqlFactory.updateTestTask, testModel);
			}
			subPhaseRunner.execute();
		}
		else dispatchComplete();
	}

	override public function destroy():void {
		super.destroy();
		sqlFactory = null;
		testModel = null;
		sqlRunner = null;
		testInfo = null;
		subPhaseRunner = null;
	}
}
}