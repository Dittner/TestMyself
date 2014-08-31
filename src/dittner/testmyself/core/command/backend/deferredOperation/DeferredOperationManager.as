package dittner.testmyself.core.command.backend.deferredOperation {
import dittner.satelliteFlight.message.RequestMessage;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.utils.pendingInvoke.clearDelay;
import dittner.testmyself.deutsch.utils.pendingInvoke.doLaterInMSec;

import flash.utils.getQualifiedClassName;

public class DeferredOperationManager extends SFProxy implements IDeferredOperationManager {
	private static const TIME_OUT:Number = 60 * 1000;//ms

	public function DeferredOperationManager() {
	}

	private var processingCmd:IDeferredOperation;
	private var commandsQueue:Array = [];
	private var timeOutFuncIndex:Number;

	public function add(op:IDeferredOperation):void {
		commandsQueue.push(op);
		executeNextCommand();
	}

	private function executeNextCommand():void {
		if (!processingCmd && hasDeferredCmd()) {
			sendRequest(ScreenMsg.LOCK, new RequestMessage());
			processingCmd = commandsQueue.shift();
			trace("deferred deferredOperation: " + getQualifiedClassName(processingCmd) + ", start processing...");
			processingCmd.addCompleteCallback(commandCompleteHandler);
			processingCmd.addErrorCallback(commandCompleteHandler);
			timeOutFuncIndex = doLaterInMSec(timeOutHandler, TIME_OUT);
			processingCmd.process();
		}
	}

	private function hasDeferredCmd():Boolean {
		return commandsQueue.length > 0;
	}

	private function commandCompleteHandler(res:* = null):void {
		trace("deferred deferredOperation complete");
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
		commandCompleteHandler();
	}
}
}
