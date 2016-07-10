package de.dittner.testmyself.ui {
import de.dittner.satelliteFlight.command.IConfigureCommand;
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.satelliteFlight.module.RootModule;
import de.dittner.testmyself.backend.command.app.ConfigureMainModuleCmd;
import de.dittner.testmyself.ui.message.ScreenMsg;
import de.dittner.testmyself.ui.service.screenFactory.ScreenID;
import de.dittner.testmyself.ui.view.main.MainView;
import de.dittner.testmyself.ui.view.main.MainViewMediator;

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
		sendRequest(ScreenMsg.SELECT_SCREEN, new RequestMessage(null, ScreenID.ABOUT));
	}

}
}
