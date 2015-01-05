package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;

public class AllTestTaskInsertOperationPhase extends PhaseOperation {

	public function AllTestTaskInsertOperationPhase(sqlRunner:SQLRunner, notes:Array, testModel:TestModel, sqlFactory:SQLFactory, isExample:Boolean) {
		this.notes = notes;
		this.sqlRunner = sqlRunner;
		this.testModel = testModel;
		this.sqlFactory = sqlFactory;
		this.isExample = isExample;
	}

	private var notes:Array;
	private var testModel:TestModel;
	private var sqlRunner:SQLRunner;
	private var sqlFactory:SQLFactory;
	private var subPhaseRunner:PhaseRunner;
	private var isExample:Boolean;

	override public function execute():void {
		if (testModel && testModel.testInfos.length > 0) {
			subPhaseRunner = new PhaseRunner();
			subPhaseRunner.completeCallback = dispatchComplete;
			var info:TestInfo;
			if (isExample) {
				for each(info in testModel.testInfos) {
					if (info.useNoteExample) {
						for each(var example:INote in notes) {
							subPhaseRunner.addPhase(TestTaskInsertOperationSubPhase, example, info, sqlRunner, sqlFactory.insertTestExampleTask, testModel);
						}
					}
				}
			}
			else {
				for each(info in testModel.testInfos) {
					if (!info.useNoteExample) {
						for each(var note:INote in notes) {
							subPhaseRunner.addPhase(TestTaskInsertOperationSubPhase, note, info, sqlRunner, sqlFactory.insertTestTask, testModel);
						}
					}
				}
			}
			subPhaseRunner.execute();
		}
		else dispatchComplete();
	}

	override public function destroy():void {
		super.destroy();
		notes.length = 0;
		notes = null;
		testModel = null;
		sqlRunner = null;
		subPhaseRunner = null;
	}
}
}