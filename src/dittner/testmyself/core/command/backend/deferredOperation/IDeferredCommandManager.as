package dittner.testmyself.core.command.backend.deferredOperation {
import de.dittner.async.IAsyncCommand;

public interface IDeferredCommandManager {
	function add(cmd:IAsyncCommand):void;
}
}
