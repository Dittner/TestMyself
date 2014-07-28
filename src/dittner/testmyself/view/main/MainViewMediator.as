package dittner.testmyself.view.main {

import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.view.common.SelectableDataGroup;
import dittner.testmyself.view.common.screen.ScreenBase;

import flash.events.Event;

import mvcexpress.mvc.Mediator;

import mx.collections.ArrayCollection;

public class MainViewMediator extends Mediator {

	[Inject]
	public var mainView:MainView;

	private var curScreen:ScreenBase;

	override protected function onRegister():void {
		mainView.screenList.addEventListener(SelectableDataGroup.SELECTED, selectedScreenChangedHandler);
		addHandler(ScreenMsg.ON_SELECTED_SCREEN_VIEW, showSelectedScreen);
		addHandler(ScreenMsg.ON_SCREEN_INFO_LIST, showScreenInfoList);
		addHandler(ScreenMsg.LOCK_SCREEN_LIST, lock);
		addHandler(ScreenMsg.UNLOCK_SCREEN_LIST, unlock);
		sendMessage(ScreenMsg.GET_SELECTED_SCREEN_VIEW);
		sendMessage(ScreenMsg.GET_SCREEN_INFO_LIST);
	}

	private function selectedScreenChangedHandler(event:Event):void {
		sendMessage(ScreenMsg.SELECT_SCREEN, mainView.screenList.selectedItem);
		sendMessage(ScreenMsg.GET_SELECTED_SCREEN_VIEW, mainView.screenList.selectedItem);
	}

	override protected function onRemove():void {
		throw new Error("Don't remove MainMediator, don't unmediate MainView!");
	}

	private function showSelectedScreen(screen:ScreenBase):void {
		if (curScreen && curScreen.info.id == screen.info.id) return;

		if (curScreen) {
			mediatorMap.unmediate(curScreen);
			mainView.removeScreen();
		}

		screen.percentHeight = 100;
		screen.percentWidth = 100;
		mainView.addScreen(screen);
		mediatorMap.mediate(screen);

		curScreen = screen;
		mainView.selectedScreenInfo = curScreen.info;
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