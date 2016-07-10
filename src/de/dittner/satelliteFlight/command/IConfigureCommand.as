package de.dittner.satelliteFlight.command {
import de.dittner.satelliteFlight.module.SFModule;

public interface IConfigureCommand {
	function execute(module:SFModule):void;
}
}
