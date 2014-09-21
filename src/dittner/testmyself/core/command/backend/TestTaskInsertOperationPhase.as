package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;

public class TestTaskInsertOperationPhase extends PhaseOperation {

	public function TestTaskInsertOperationPhase(sqlRunner:SQLRunner, note:Note, testModel:TestModel, sqlFactory:SQLFactory) {
		this.note = note;
		this.sqlRunner = sqlRunner;
		this.testModel = testModel;
		this.sqlFactory = sqlFactory;
	}

	private var note:Note;
	private var testModel:TestModel;
	private var sqlRunner:SQLRunner;
	private var sqlFactory:SQLFactory;
	private var subPhaseRunner:PhaseRunner;

	override public function execute():void {
		if (testModel && testModel.testInfos.length > 0) {
			subPhaseRunner = new PhaseRunner();
			subPhaseRunner.completeCallback = dispatchComplete;

			for each(var info:TestInfo in testModel.testInfos) {
				subPhaseRunner.addPhase(TestTaskInsertOperationSubPhase, note, info, sqlRunner, sqlFactory.insertTestTask, testModel);
			}
			subPhaseRunner.execute();
		}
		else dispatchComplete();
	}

	override public function destroy():void {
		super.destroy();
		testModel = null;
		sqlRunner = null;
		subPhaseRunner = null;
	}
}
}