package de.dittner.testmyself.backend.deferredOperation {
import de.dittner.async.IAsyncCommand;

public interface IDeferredCommandManager {
	function add(cmd:IAsyncCommand):void;
	function start():void;
	function stop():void;
}
}
