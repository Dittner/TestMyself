package dittner.testmyself.deutsch {
import dittner.satelliteFlight.command.IConfigureCommand;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.satelliteFlight.module.RootModule;
import dittner.testmyself.deutsch.command.app.ConfigureMainModuleCmd;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.service.screenFactory.ScreenId;
import dittner.testmyself.deutsch.view.main.MainView;
import dittner.testmyself.deutsch.view.main.MainViewMediator;

import mx.core.IVisualElementContainer;

public class MainModule extends RootModule {

	public function MainModule(name:String):void {
		super(name);
		var cmd:IConfigureCommand = new ConfigureMainModuleCmd();
		cmd.execute(this);
	}

	public function start(root:IVisualElementContainer):void {
		const mainView:MainView = new MainView();
		mainView.percentHeight = 100;
		mainView.percentWidth = 100;
		root.addElement(mainView);
		registerMediator(mainView, new MainViewMediator());
		sendRequest(ScreenMsg.SELECT_SCREEN, new RequestMessage(null, null, ScreenId.ABOUT));
	}

}
}
