package dittner.satelliteFlight.command {
import dittner.satelliteFlight.module.SFModule;

public interface IConfigureCommand {
	function execute(module:SFModule):void;
}
}
