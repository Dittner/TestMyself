package dittner.testmyself.core.command.backend.deferredOperation {
import dittner.testmyself.core.async.ICommand;

public interface IDeferredCommandManager {
	function add(cmd:ICommand):void;
}
}
