package dittner.testmyself.command.backend.common {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.phrase.*;
import dittner.testmyself.command.operation.deferredOperation.DeferredOperation;
import dittner.testmyself.command.operation.phaseOperation.PhaseRunner;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.common.DataBaseInfo;

public class GetPhraseDBInfoOperation extends DeferredOperation {

	public function GetPhraseDBInfoOperation(sqlRunner:SQLRunner) {
		this.sqlRunner = sqlRunner;
		info = new DataBaseInfo();
	}

	private var sqlRunner:SQLRunner;
	private var info:DataBaseInfo;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(PhraseCountTransactionPhase, sqlRunner, info);
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