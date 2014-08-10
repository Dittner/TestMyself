package dittner.testmyself.command.core.deferredOperation {

public interface IDeferredOperation {
	function addCompleteCallback(handler:Function):void;
	function addErrorCallback(handler:Function):void;
	function process():void;
}
}
