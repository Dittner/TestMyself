package de.dittner.satelliteFlight.command {
import de.dittner.satelliteFlight.message.IRequestMessage;

public interface ISFCommand {
	function execute(msg:IRequestMessage):void;
}
}
