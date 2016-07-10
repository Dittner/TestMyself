package de.dittner.testmyself.backend.command {
import de.dittner.async.AsyncOperation;
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.message.IRequestMessage;
import de.dittner.testmyself.backend.NoteService;
import de.dittner.testmyself.model.domain.note.INoteModel;

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
