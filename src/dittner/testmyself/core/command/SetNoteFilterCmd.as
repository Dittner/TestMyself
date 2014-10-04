package dittner.testmyself.core.command {
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.model.note.INoteModel;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.service.NoteService;

public class SetNoteFilterCmd implements ISFCommand {

	[Inject]
	public var service:NoteService;

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {
		model.filter = msg.data as NoteFilter;
		service.loadNotePageInfo(new RequestMessage(null, null, 0));
		service.loadDBInfo(msg);
	}
}
}
