package dittner.testmyself.core.command {
import de.dittner.async.AsyncOperation;

import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.core.model.note.INoteModel;
import dittner.testmyself.core.service.NoteService;

public class GetNotesInfoCmd implements ISFCommand {

	[Inject]
	public var service:NoteService;

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {
		if (model.dataBaseInfo) {
			var op:AsyncOperation = new AsyncOperation();
			op.dispatchSuccess(model.dataBaseInfo);
			msg.onComplete(op);
		}
		else {
			service.loadDBInfo(msg);
		}
	}
}
}