package de.dittner.testmyself.backend.command {
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.message.IRequestMessage;
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.testmyself.backend.NoteService;
import de.dittner.testmyself.model.domain.note.INoteModel;
import de.dittner.testmyself.model.domain.note.NoteFilter;

public class SetNoteFilterCmd implements ISFCommand {

	[Inject]
	public var service:NoteService;

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {
		model.filter = msg.data as NoteFilter;
		service.loadNotePageInfo(new RequestMessage(null, 0));
		service.loadDBInfo(msg);
	}
}
}
