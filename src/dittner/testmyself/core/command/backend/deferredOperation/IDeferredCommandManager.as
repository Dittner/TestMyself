package dittner.testmyself.core.command.backend.deferredOperation {
import dittner.async.IAsyncCommand;

public interface IDeferredCommandManager {
	function add(cmd:IAsyncCommand):void;
}
}
