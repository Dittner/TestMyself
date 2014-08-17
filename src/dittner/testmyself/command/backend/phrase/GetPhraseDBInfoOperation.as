package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.deferredOperation.DeferredOperation;
import dittner.testmyself.command.operation.phaseOperation.PhaseRunner;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.common.DataBaseInfo;

public class GetPhraseDBInfoOperation extends DeferredOperation {

	public function GetPhraseDBInfoOperation(sqlRunner:SQLRunner, filter:Array) {
		this.sqlRunner = sqlRunner;
		this.filter = filter;
		info = new DataBaseInfo();
	}

	private var sqlRunner:SQLRunner;
	private var info:DataBaseInfo;
	private var filter:Array;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(PhraseCountTransactionPhase, sqlRunner, info);
			phaseRunner.addPhase(FilteredPhraseCountTransactionPhase, sqlRunner, info, filter);
			phaseRunner.addPhase(PhraseAudioCountTransactionPhase, sqlRunner, info);

			phaseRunner.execute();
		}
		catch (exc:CommandException) {
			phaseRunner.destroy();
			dispatchCompleteWithError(exc);
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchCompleteSuccess(new CommandResult(info));
	}
}
}