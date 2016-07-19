package de.dittner.testmyself.backend.command {
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.note.INoteModel;
import de.dittner.testmyself.model.domain.note.NoteFilter;

public class SetNoteFilterCmd implements ISFCommand {

	[Inject]
	public var service:SQLStorage;

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {
		model.filter = msg.data as NoteFilter;
		service.loadNotePageInfo(new RequestMessage(null, 0));
		service.loadDBInfo(msg);
	}
}
}
