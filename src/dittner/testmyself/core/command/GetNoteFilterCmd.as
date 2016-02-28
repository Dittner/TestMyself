package dittner.testmyself.core.command {
import dittner.async.AsyncOperation;
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.core.model.note.INoteModel;

public class GetNoteFilterCmd implements ISFCommand {

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {
		var op:AsyncOperation = new AsyncOperation();
		op.dispatchSuccess(model.filter);
		msg.onComplete(op);
	}
}
}
