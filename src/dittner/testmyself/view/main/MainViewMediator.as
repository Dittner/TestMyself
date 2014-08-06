package dittner.testmyself.view.main {

import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.service.helpers.screenFactory.ScreenId;
import dittner.testmyself.view.common.SelectableDataGroup;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.mediator.SmartMediator;
import dittner.testmyself.view.common.screen.ScreenBase;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class MainViewMediator extends SmartMediator {

	[Inject]
	public var mainView:MainView;

	private var selectedScreen:ScreenBase;
	private var selectedScreenID:uint = ScreenId.ABOUT;

	override protected function onRegister():void {
		addHandler(ScreenMsg.LOCK_UI, lock);
		addHandler(ScreenMsg.UNLOCK_UI, unlock);

		sendRequest(ScreenMsg.GET_SCREEN_INFO_LIST, new RequestMessage(showScreenInfoList));
		sendRequest(ScreenMsg.GENERATE_SCREEN, new RequestMessage(showSelectedScreen, null, selectedScreenID));

		mainView.screenList.addEventListener(SelectableDataGroup.SELECTED, selectedScreenChangedHandler);
	}

	private function selectedScreenChangedHandler(event:Event):void {
		selectedScreenID = mainView.screenList.selectedItem.id;
		sendRequest(ScreenMsg.GENERATE_SCREEN, new RequestMessage(showSelectedScreen, null, selectedScreenID));
	}

	override protected function onRemove():void {
		throw new Error("Don't remove MainMediator, don't unmediate MainView!");
	}

	private function showSelectedScreen(screen:ScreenBase):void {
		if (selectedScreen) {
			mediatorMap.unmediate(selectedScreen);
			mainView.removeScreen();
		}

		screen.percentHeight = 100;
		screen.percentWidth = 100;
		mainView.addScreen(screen);
		mediatorMap.mediate(screen);

		selectedScreen = screen;
	}

	private function showScreenInfoList(screenInfos:Array):void {
		mainView.screenListProvider = new ArrayCollection(screenInfos);
	}

	private function lock(params:Object):void {
		mainView.lock();
	}

	private function unlock(params:Object):void {
		mainView.unlock();
	}

}
}