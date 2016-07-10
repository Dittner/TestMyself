package de.dittner.testmyself.backend.command {
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.message.IRequestMessage;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.note.INoteModel;

public class SelectNoteCmd implements ISFCommand {

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {
		model.selectedNote = msg.data as INote;
	}

}
}