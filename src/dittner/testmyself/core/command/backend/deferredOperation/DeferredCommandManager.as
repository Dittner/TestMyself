package dittner.testmyself.core.command.backend.deferredOperation {
import dittner.async.IAsyncCommand;
import dittner.async.IAsyncOperation;
import dittner.async.utils.clearDelay;
import dittner.async.utils.doLaterInMSec;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.deutsch.message.ScreenMsg;

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
		//trace("deferred cmd complete");
		destroyProcessingCmd();
		executeNextCommand();
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
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
