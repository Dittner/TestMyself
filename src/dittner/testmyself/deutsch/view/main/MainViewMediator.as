package dittner.testmyself.deutsch.view.main {

import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.view.common.list.SelectableDataGroup;
import dittner.testmyself.deutsch.view.common.screen.ScreenBase;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class MainViewMediator extends SFMediator {

	[Inject]
	public var view:MainView;

	override protected function activate():void {
		addListener(ScreenMsg.LOCK_NOTIFICATION, lock);
		addListener(ScreenMsg.UNLOCK_NOTIFICATION, unlock);
		addListener(ScreenMsg.SELECTED_SCREEN_CHANGED_NOTIFICATION, selectedScreenChanged);

		sendRequest(ScreenMsg.GET_SELECTED_SCREEN, new RequestMessage(selectedScreenLoaded));
		sendRequest(ScreenMsg.GET_SCREEN_INFO_LIST, new RequestMessage(showScreenInfoList));

		view.screenList.addEventListener(SelectableDataGroup.SELECTED, screenListItemSelectedHandler);
	}

	private function showScreenInfoList(res:CommandResult):void {
		var screenInfos:Array = res.data as Array;
		view.screenListProvider = new ArrayCollection(screenInfos);
		view.screenList.selectedIndex = 0;
	}

	private function selectedScreenChanged(screen:ScreenBase):void {
		showScreen(screen);
	}

	private function selectedScreenLoaded(res:CommandResult):void {
		showScreen(res.data as ScreenBase);
	}

	private function showScreen(screen:ScreenBase):void {
		view.removeScreen();
		if (screen) {
			screen.percentHeight = 100;
			screen.percentWidth = 100;
			view.addScreen(screen);
		}
	}

	private function screenListItemSelectedHandler(event:Event):void {
		sendRequest(ScreenMsg.SELECT_SCREEN, new RequestMessage(null, null, view.screenList.selectedItem.id));
	}

	override protected function deactivate():void {
		throw new Error("Don't remove MainMediator, don't unregister MainView!");
	}

	private function lock(data:*):void {
		view.lock();
	}

	private function unlock(data:*):void {
		view.unlock();
	}

}
}