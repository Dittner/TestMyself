package dittner.testmyself.core.command {
import dittner.async.AsyncOperation;
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
			var op:AsyncOperation = new AsyncOperation();
			op.dispatchSuccess(model.pageInfo);
			msg.onComplete(op);
		}
		else {
			service.loadNotePageInfo(msg);
		}
	}
}
}
