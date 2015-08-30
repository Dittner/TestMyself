package dittner.testmyself.core.async {
import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.deutsch.utils.pendingInvalidation.invalidateOf;
import dittner.testmyself.deutsch.utils.pendingInvoke.clearDelay;
import dittner.testmyself.deutsch.utils.pendingInvoke.doLaterInMSec;

public class AsyncOperation implements IAsyncOperation {
	public function AsyncOperation() {}

	private static var totalOperations:Number = 0;
	public var _uid:Number = totalOperations++;
	public function get uid():Number {return _uid;}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  timeoutInSec
	//--------------------------------------
	private var _timeoutInSec:Number = 0;
	public function get timeoutInSec():Number {return _timeoutInSec;}
	public function set timeoutInSec(value:Number):void {
		if (_timeoutInSec != value) {
			_timeoutInSec = value;
			startTimeout();
		}
	}

	//--------------------------------------
	//  result
	//--------------------------------------
	private var _result:*;
	public function get result():* {return _result;}

	//--------------------------------------
	//  isSuccess
	//--------------------------------------
	private var _isSuccess:Boolean;
	public function get isSuccess():Boolean {return _isSuccess;}

	//--------------------------------------
	//  isTimeout
	//--------------------------------------
	private var _isTimeout:Boolean = false;
	public function get isTimeout():Boolean {return _isTimeout;}

	//--------------------------------------
	//  error
	//--------------------------------------
	private var _error:* = "";
	public function get error():* {return _error;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private var timeoutInd:int = NaN;
	protected function startTimeout():void {
		stopTimeout();
		if (timeoutInSec > 0) timeoutInd = doLaterInMSec(timeoutHandler, timeoutInSec * 1000);
	}

	protected function stopTimeout():void {
		if (!isNaN(timeoutInd)) {
			clearDelay(timeoutInd);
			timeoutInd = NaN;
		}
	}

	protected function timeoutHandler():void {
		timeoutInd = NaN;
		_isTimeout = true;
		dispatchError("Timeout!");
	}

	private var completeCallbackQueue:Array = [];
	public function addCompleteCallback(handler:Function):void {
		completeCallbackQueue.push(handler);
	}

	public function dispatchSuccess(result:* = null):void {
		_result = result;
		_isSuccess = true;
		invalidateOf(completeExecute);
	}

	public function dispatchError(error:* = null):void {
		if (error is String) trace(error);
		else if (error is Error) trace(error.toString());
		else if (error is CommandException) trace((error as CommandException).details);

		_error = error;
		_isSuccess = false;
		invalidateOf(completeExecute);
	}

	protected function completeExecute():void {
		for each(var handler:Function in completeCallbackQueue) handler(this);
		stopTimeout();
		destroy();
	}

	public function destroy():void {
		removeAllCallbacks();
	}

	protected function removeAllCallbacks():void {
		completeCallbackQueue.length = 0;
	}

}
}
