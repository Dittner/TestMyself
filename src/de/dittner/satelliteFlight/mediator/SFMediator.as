package de.dittner.satelliteFlight.mediator {
import de.dittner.satelliteFlight.SFComponent;
import de.dittner.satelliteFlight.module.SFModule;
import de.dittner.satelliteFlight.sf_namespace;
import de.dittner.satelliteFlight.utils.SFConstants;
import de.dittner.satelliteFlight.utils.SFException;
import de.dittner.satelliteFlight.utils.SFExceptionMsg;

use namespace sf_namespace;

public class SFMediator extends SFComponent {
	public function SFMediator() {}

	private var children:Array = [];

	public function registerMediator(view:Object, mediator:SFMediator):void {
		children.push(mediator);
		if (injector.hasInjectDeclaration(mediator, SFConstants.MEDIATOR_VIEW_INJECT_NAME)) {
			mediator[SFConstants.MEDIATOR_VIEW_INJECT_NAME] = view;
			injector.injectMediator(mediator, moduleName);
		}
		mediator.module = module;
		mediator.messageSender = messageSender;
		mediator.injector = injector;
		mediator.activating();
	}

	public function registerMediatorTo(moduleName:String, view:Object, mediator:SFMediator):void {
		var destModule:SFModule = module.getModule(moduleName);
		if (!destModule) throw new SFException(SFExceptionMsg.MODULE_NOT_FOUND);

		destModule.registerMediator(view, mediator);
	}

	public function unregisterMediator(mediator:SFMediator):void {
		for (var i:int = 0; i < children.length; i++)
			if (children[i] == mediator) {
				children.splice(i, 1);
				mediator.deactivating();
				break;
			}
	}

	public function unregisterMediatorFrom(moduleName:String, mediator:SFMediator):void {
		var srcModule:SFModule = module.getModule(moduleName);
		if (!srcModule) throw new SFException(SFExceptionMsg.MODULE_NOT_FOUND);

		srcModule.unregisterMediator(mediator);
	}

	override sf_namespace function deactivating():void {
		super.deactivating();
		for each(var m:SFMediator in children) m.deactivating();
		children.length = 0;
	}

}
}
