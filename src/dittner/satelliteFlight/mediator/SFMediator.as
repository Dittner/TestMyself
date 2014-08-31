package dittner.satelliteFlight.mediator {
import dittner.satelliteFlight.SFComponent;
import dittner.satelliteFlight.sf_namespace;
import dittner.satelliteFlight.utils.SFConstants;

use namespace sf_namespace;

public class SFMediator extends SFComponent {
	public function SFMediator() {}

	private var children:Array = [];

	public function registerMediator(view:Object, mediator:SFMediator):void {
		children.push(mediator);
		if (injector.hasInjectDeclaration(mediator, SFConstants.MEDIATOR_VIEW_INJECT_NAME)) {
			mediator[SFConstants.MEDIATOR_VIEW_INJECT_NAME] = view;
		}
		mediator.moduleName = moduleName;
		mediator.messageSender = messageSender;
		mediator.injector = injector;
		mediator.activating();
	}

	public function unregisterMediator(mediator:SFMediator):void {
		for (var i:int = 0; i < children.length; i++)
			if (children[i] == mediator) {
				children.splice(i, 1);
				mediator.deactivating();
				break;
			}
	}

	override sf_namespace function deactivating():void {
		super.deactivating();
		for each(var m:SFMediator in children) m.deactivating();
		children.length = 0;
	}

}
}
