package de.dittner.testmyself.backend.deferredOperation {
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.async.utils.clearDelay;
import de.dittner.async.utils.doLaterInMSec;
import de.dittner.testmyself.ui.message.ScreenMsg;

public class DeferredCommandManager extends SFProxy implements IDeferredCommandManager {
	private static const TIME_OUT:Number = 60 * 1000;//ms

	public function DeferredCommandManager() {}

	private var processingCmd:IAsyncCommand;
	private var commandsQueue:Array = [];
	private var timeOutFuncIndex:Number;

	public function add(cmd:IAsyncCommand):void {
		commandsQueue.push(cmd);
		executeNextCommand();
	}

	private function executeNextCommand():void {
		if (!processingCmd && hasDeferredCmd()) {
			sendRequest(ScreenMsg.LOCK, new RequestMessage());
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
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
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
