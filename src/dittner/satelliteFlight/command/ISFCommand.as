package dittner.satelliteFlight.command {
import dittner.satelliteFlight.message.IRequestMessage;

public interface ISFCommand {
	function execute(msg:IRequestMessage):void;
}
}
