package de.dittner.testmyself.backend.command {
import de.dittner.async.AsyncOperation;
import de.dittner.testmyself.ui.common.view.IViewFactory;

public class GetScreenInfoListCmd implements ISFCommand {

	[Inject]
	public var screenFactory:IViewFactory;

	public function execute(msg:IRequestMessage):void {
		var op:AsyncOperation = new AsyncOperation();
		op.dispatchSuccess(screenFactory.viewInfos);
		msg.onComplete(op);
	}

}
}