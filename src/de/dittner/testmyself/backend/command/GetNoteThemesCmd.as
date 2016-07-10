package de.dittner.testmyself.backend.command {
import de.dittner.async.AsyncOperation;
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.message.IRequestMessage;
import de.dittner.testmyself.backend.NoteService;
import de.dittner.testmyself.model.domain.note.INoteModel;

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