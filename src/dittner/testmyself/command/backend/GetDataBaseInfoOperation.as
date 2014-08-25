package dittner.testmyself.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.model.common.DataBaseInfo;

public class GetDataBaseInfoOperation extends DeferredOperation {

	public function GetDataBaseInfoOperation(sqlRunner:SQLRunner, filter:Array, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.filter = filter;
		this.sqlFactory = sqlFactory;
		info = new DataBaseInfo();
	}

	private var sqlRunner:SQLRunner;
	private var info:DataBaseInfo;
	private var filter:Array;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(TransUnitCountTransactionPhase, sqlRunner, info, sqlFactory);
			phaseRunner.addPhase(FilteredTransUnitCountTransactionPhase, sqlRunner, info, filter, sqlFactory);
			phaseRunner.addPhase(TransUnitWithAudioCountTransactionPhase, sqlRunner, info, sqlFactory);

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