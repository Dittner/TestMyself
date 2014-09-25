package dittner.testmyself.core.command {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.core.model.note.INoteModel;
import dittner.testmyself.core.service.NoteService;

public class GetNotePageInfoCmd implements ISFCommand {

	[Inject]
	public var service:NoteService;

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {
		var pageNum:uint = msg.data as uint;
		if (model.pageInfo && model.pageInfo.pageNum == pageNum) {
			msg.completeSuccess(new CommandResult(model.pageInfo));
		}
		else {
			service.loadNotePageInfo(msg);
		}
	}
}
}
