package de.dittner.testmyself.backend.deferredOperation {
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.async.utils.clearDelay;
import de.dittner.async.utils.doLaterInMSec;
import de.dittner.testmyself.ui.view.main.MainVM;
import de.dittner.walter.WalterProxy;

public class DeferredCommandManager extends WalterProxy implements IDeferredCommandManager {
	private static const TIME_OUT:Number = 60 * 1000;//ms

	public function DeferredCommandManager() {
		super();
	}

	[Inject]
	public var mainVM:MainVM;

	private var processingCmd:IAsyncCommand;
	private var commandsQueue:Array = [];
	private var timeOutFuncIndex:Number;

	public function add(cmd:IAsyncCommand):void {
		commandsQueue.push(cmd);
		executeNextCommand();
	}

	private function executeNextCommand():void {
		if (!processingCmd && hasDeferredCmd()) {
			mainVM.viewLocked = true;
			processingCmd = commandsQueue.shift();
			//trace("deferred deferredOperation: " + getQualifiedClassName(processingCmd) + ", start processing...");
			processingCmd.addCompleteCallback(commandCompleteHandler);
			timeOutFuncIndex = doLaterInMSec(timeOutHandler, TIME_OUT);
			processingCmd.execute();
		}
	}

	private function hasDeferredCmd():Boolean {
		return commandsQueue.length > 0;
	}

	private function commandCompleteHandler(op:IAsyncOperation):void {
		mainVM.viewLocked = false;
		destroyProcessingCmd();
		executeNextCommand();
	}

	private function destroyProcessingCmd():void {
		processingCmd = null;
		clearDelay(timeOutFuncIndex);
		timeOutFuncIndex = NaN;
	}

	private function timeOutHandler():void {
		trace("time out");
		commandCompleteHandler(processingCmd);
	}
}
}
