package dittner.testmyself.service.helpers.deferredComandManager {
import dittner.testmyself.command.DeferredCommand;

public interface IDeferredCommandManager {
	function push(cmd:DeferredCommand):void;
}
}
