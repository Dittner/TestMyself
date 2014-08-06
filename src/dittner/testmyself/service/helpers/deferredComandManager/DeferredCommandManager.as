package dittner.testmyself.service.helpers.deferredComandManager {
import dittner.testmyself.command.DeferredCommand;
import dittner.testmyself.utils.pendingInvoke.clearDelay;
import dittner.testmyself.utils.pendingInvoke.doLaterInMSec;

import mvcexpress.mvc.Proxy;

public class DeferredCommandManager extends Proxy implements IDeferredCommandManager {
	private static const TIME_OUT:Number = 60 * 1000;//ms

	public function DeferredCommandManager() {
	}

	private var processingCmd:DeferredCommand;
	private var commandsQueue:Array = [];
	private var timeOutFuncIndex:Number;

	public function push(cmd:DeferredCommand):void {
		commandsQueue.push(cmd);
		executeNextCommand();
	}

	private function executeNextCommand():void {
		if (!processingCmd && hasDeferredCmd()) {
			trace("deferred cmd start processing...");
			processingCmd = commandsQueue.shift();
			processingCmd.completeFunc = commandCompleteHandler;
			processingCmd.errorFunc = commandErrorHandler;
			timeOutFuncIndex = doLaterInMSec(timeOutHandler, TIME_OUT);
			processingCmd.process();
		}
	}

	private function hasDeferredCmd():Boolean {
		return commandsQueue.length > 0;
	}

	private function commandCompleteHandler():void {
		trace("deferred cmd success completed");
		destroyProcessingCmd();
		executeNextCommand();
	}

	private function commandErrorHandler(msg:String = null):void {
		trace("deferred cmd completed with error : " + msg);
		destroyProcessingCmd();
		executeNextCommand();
	}

	private function destroyProcessingCmd():void {
		processingCmd.completeFunc = null;
		processingCmd.errorFunc = null;
		processingCmd = null;
		clearDelay(timeOutFuncIndex);
		timeOutFuncIndex = NaN;
	}

	private function timeOutHandler():void {
		commandErrorHandler("time out");
	}
}
}
