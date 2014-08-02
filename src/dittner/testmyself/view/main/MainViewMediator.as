package dittner.testmyself.view.main {

import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.view.common.SelectableDataGroup;
import dittner.testmyself.view.common.mediator.RequestOperationMessage;
import dittner.testmyself.view.common.mediator.SmartMediator;
import dittner.testmyself.view.common.screen.ScreenBase;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class MainViewMediator extends SmartMediator {

	[Inject]
	public var mainView:MainView;

	private var curScreen:ScreenBase;

	override protected function onRegister():void {
		requestData(ScreenMsg.GET_SCREEN_INFO_LIST, new RequestOperationMessage(showScreenInfoList));
		requestData(ScreenMsg.GET_SELECTED_SCREEN_VIEW, new RequestOperationMessage(showSelectedScreen));

		addHandler(ScreenMsg.LOCK_UI, lock);
		addHandler(ScreenMsg.UNLOCK_UI, unlock);

		mainView.screenList.addEventListener(SelectableDataGroup.SELECTED, selectedScreenChangedHandler);
	}

	private function selectedScreenChangedHandler(event:Event):void {
		var selectedScreenId:uint = mainView.screenList.selectedItem.id;
		sendMessage(ScreenMsg.SELECT_SCREEN, selectedScreenId);
		requestData(ScreenMsg.GET_SELECTED_SCREEN_VIEW, new RequestOperationMessage(showSelectedScreen));
	}

	override protected function onRemove():void {
		throw new Error("Don't remove MainMediator, don't unmediate MainView!");
	}

	private function showSelectedScreen(screen:ScreenBase):void {
		if (curScreen) {
			mediatorMap.unmediate(curScreen);
			mainView.removeScreen();
		}

		screen.percentHeight = 100;
		screen.percentWidth = 100;
		mainView.addScreen(screen);
		mediatorMap.mediate(screen);

		curScreen = screen;
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