package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.command.backend.utils.SQLFactory;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.theme.Theme;

public class FilterInsertOperationPhase extends PhaseOperation {

	public function FilterInsertOperationPhase(sqlRunner:SQLRunner, note:Note, themes:Array, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.note = note;
		this.themes = themes;
		this.sqlFactory = sqlFactory;
	}

	private var note:Note;
	private var themes:Array;
	private var sqlFactory:SQLFactory;
	private var sqlRunner:SQLRunner;
	private var subPhaseRunner:PhaseRunner;

	override public function execute():void {
		if (themes.length > 0) {
			subPhaseRunner = new PhaseRunner();
			subPhaseRunner.completeCallback = dispatchComplete;

			for each(var theme:Theme in themes) {
				subPhaseRunner.addPhase(FilterInsertOperationSubPhase, note, theme, sqlRunner, sqlFactory.insertFilter);
			}
			subPhaseRunner.execute();
		}
		else dispatchComplete();
	}
}
}
