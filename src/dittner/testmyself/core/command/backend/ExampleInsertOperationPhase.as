package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.SQLFactory;

public class ExampleInsertOperationPhase extends PhaseOperation {

	public function ExampleInsertOperationPhase(sqlRunner:SQLRunner, note:Note, examples:Array, sqlFactory:SQLFactory) {
		this.note = note;
		this.sqlRunner = sqlRunner;
		this.examples = examples;
		this.sqlFactory = sqlFactory;
	}

	private var note:Note;
	private var examples:Array;
	private var sqlRunner:SQLRunner;
	private var sqlFactory:SQLFactory;
	private var subPhaseRunner:PhaseRunner;

	override public function execute():void {
		if (examples && examples.length > 0) {
			subPhaseRunner = new PhaseRunner();
			subPhaseRunner.completeCallback = dispatchComplete;

			for each(var example:INote in examples) {
				subPhaseRunner.addPhase(MP3EncodingPhase, example);
				subPhaseRunner.addPhase(ExampleInsertOperationSubPhase, note.id, example, sqlRunner, sqlFactory.insertExample);
			}
			subPhaseRunner.execute();
		}
		else dispatchComplete();
	}

	override public function destroy():void {
		super.destroy();
		examples = null;
		sqlRunner = null;
		subPhaseRunner = null;
	}
}
}