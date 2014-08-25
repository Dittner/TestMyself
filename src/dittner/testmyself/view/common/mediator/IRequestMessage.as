package dittner.testmyself.view.common.mediator {
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.result.CommandResult;

public interface IRequestMessage {
	function get data():Object;
	function completeSuccess(res:CommandResult):void;
	function completeWithError(exc:CommandException):void;
}
}
