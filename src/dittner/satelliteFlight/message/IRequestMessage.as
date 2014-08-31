package dittner.satelliteFlight.message {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;

public interface IRequestMessage {
	function get data():Object;
	function completeSuccess(res:CommandResult):void;
	function completeWithError(exc:CommandException):void;
}
}
