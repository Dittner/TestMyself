package dittner.testmyself {
import dittner.testmyself.command.app.ConfigureAppCmd;
import dittner.testmyself.view.main.MainView;
import dittner.testmyself.view.main.MainViewMediator;

import mvcexpress.modules.ModuleCore;

import mx.core.IVisualElementContainer;

public class MainModule extends ModuleCore {

	public function MainModule(moduleName:String):void {
		super(moduleName);
	}

	override protected function onInit():void {
		commandMap.execute(ConfigureAppCmd);
	}

	public function start(root:IVisualElementContainer):void {
		const mainView:MainView = new MainView();
		mainView.percentHeight = 100;
		mainView.percentWidth = 100;
		root.addElement(mainView);
		mediatorMap.mediateWith(mainView, MainViewMediator);
	}

}
}
