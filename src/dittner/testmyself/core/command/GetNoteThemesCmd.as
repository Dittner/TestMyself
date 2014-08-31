package dittner.testmyself.core.command {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.core.model.note.INoteModel;
import dittner.testmyself.core.service.NoteService;

public class GetNoteThemesCmd implements ISFCommand {

	[Inject]
	public var service:NoteService;

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {
		if (model.themes) msg.completeSuccess(new CommandResult(model.themes));
		else service.loadThemes(msg);
	}

}
}