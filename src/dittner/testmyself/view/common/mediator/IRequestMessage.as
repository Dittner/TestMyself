package dittner.testmyself.view.common.mediator {
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;

public interface IRequestMessage {
	function get data():Object;
	function completeSuccess(res:CommandResult):void;
	function completeWithError(exc:CommandException):void;
}
}
