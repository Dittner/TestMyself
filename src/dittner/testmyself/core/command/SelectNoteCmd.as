package dittner.testmyself.core.command {
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.note.INoteModel;

public class SelectNoteCmd implements ISFCommand {

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {
		model.selectedNote = msg.data as INote;
	}

}
}