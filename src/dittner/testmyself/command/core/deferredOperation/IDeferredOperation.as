package dittner.testmyself.command.core.deferredOperation {

public interface IDeferredOperation {
	function addCompleteCallback(handler:*):void;
	function process():void;
}
}
