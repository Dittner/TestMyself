package dittner.testmyself.core.command {
import dittner.async.AsyncOperation;
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.core.model.note.INoteModel;

public class GetNoteHashCmd implements ISFCommand {

	[Inject]
	public var model:INoteModel;

	public function execute(msg:IRequestMessage):void {
		var op:AsyncOperation = new AsyncOperation();
		op.dispatchSuccess(model.noteHash);
		msg.onComplete(op);
	}

}
}