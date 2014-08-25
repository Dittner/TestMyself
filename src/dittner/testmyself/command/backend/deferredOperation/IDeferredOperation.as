package dittner.testmyself.command.backend.deferredOperation {

public interface IDeferredOperation {
	function addCompleteCallback(handler:Function):void;
	function addErrorCallback(handler:Function):void;
	function process():void;
}
}
