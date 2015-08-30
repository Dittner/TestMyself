package dittner.testmyself.core.command {
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.model.note.INoteModel;
import dittner.testmyself.core.service.NoteService;

public class GetNoteThemesCmd implements ISFCommand {

	[Inject]
	public var service:NoteService;

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {

		if (model.themes) {
			var op:AsyncOperation = new AsyncOperation();
			op.dispatchSuccess(model.themes);
			msg.onComplete(op);
		}
		else {
			service.loadThemes(msg);
		}
	}

}
}