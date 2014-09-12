package dittner.testmyself.core.command {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.core.model.note.INoteModel;

public class GetNoteHashCmd implements ISFCommand {

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {
		msg.completeSuccess(new CommandResult(model.noteHash));
	}

}
}