package dittner.testmyself.command.operation.deferredOperation {
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.utils.pendingInvoke.clearDelay;
import dittner.testmyself.utils.pendingInvoke.doLaterInMSec;

import flash.utils.getQualifiedClassName;

import mvcexpress.mvc.Proxy;

public class DeferredOperationManager extends Proxy implements IDeferredOperationManager {
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
			sendMessage(ScreenMsg.LOCK_UI);
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
		sendMessage(ScreenMsg.UNLOCK_UI);
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
