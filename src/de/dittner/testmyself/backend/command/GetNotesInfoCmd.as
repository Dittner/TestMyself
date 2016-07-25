package de.dittner.testmyself.backend.command {
import de.dittner.async.AsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.note.INoteModel;

public class GetNotesInfoCmd implements ISFCommand {

	[Inject]
	public var service:SQLStorage;

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {
		if (model.dataBaseInfo) {
			var op:AsyncOperation = new AsyncOperation();
			op.dispatchSuccess(model.dataBaseInfo);
			msg.onComplete(op);
		}
		else {
			service.loadLanguageInfo(msg);
		}
	}
}
}