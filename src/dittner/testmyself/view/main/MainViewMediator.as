package dittner.testmyself.view.main {

import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.service.screenFactory.ScreenId;
import dittner.testmyself.view.common.SelectableDataGroup;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.screen.ScreenBase;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class MainViewMediator extends RequestMediator {

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

	private function showSelectedScreen(res:CommandResult):void {
		var screen:ScreenBase = res.data as ScreenBase;
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

	private function showScreenInfoList(res:CommandResult):void {
		var screenInfos:Array = res.data as Array;
		mainView.screenListProvider = new ArrayCollection(screenInfos);
		mainView.screenList.selectedIndex = 0;
	}

	private var lockRequestNum:int = 0;
	private function lock(params:Object):void {
		mainView.lock();
		lockRequestNum++;
	}

	private function unlock(params:Object):void {
		if (lockRequestNum > 0) lockRequestNum--;
		if (lockRequestNum == 0) mainView.unlock();
	}

}
}