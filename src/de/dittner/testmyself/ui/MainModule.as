package de.dittner.testmyself.ui {
import de.dittner.testmyself.backend.command.ConfigureMainModuleCmd;
import de.dittner.testmyself.ui.common.view.ViewID;
import de.dittner.testmyself.ui.message.ScreenMsg;
import de.dittner.testmyself.ui.view.main.MainVM;
import de.dittner.testmyself.ui.view.main.MainView;

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
		registerMediator(mainView, new MainVM());
		sendRequest(ScreenMsg.SELECT_SCREEN, new RequestMessage(null, ViewID.ABOUT));
	}

}
}
