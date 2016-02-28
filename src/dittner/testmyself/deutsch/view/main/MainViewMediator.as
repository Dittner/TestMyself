package dittner.testmyself.deutsch.view.main {

import dittner.async.IAsyncOperation;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.view.common.list.SelectableDataGroup;
import dittner.testmyself.deutsch.view.common.screen.ScreenBase;
import dittner.testmyself.deutsch.view.main.tafel.TafelMediator;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class MainViewMediator extends SFMediator {

	[Inject]
	public var view:MainView;

	override protected function activate():void {
		lock();

		registerMediator(view.tafel, new TafelMediator());

		addListener(ScreenMsg.START_EDIT_NOTIFICATION, startEditing);
		addListener(ScreenMsg.END_EDIT_NOTIFICATION, endEditing);
		addListener(ScreenMsg.LOCK_NOTIFICATION, lock);
		addListener(ScreenMsg.UNLOCK_NOTIFICATION, unlock);
		addListener(ScreenMsg.SELECTED_SCREEN_CHANGED_NOTIFICATION, selectedScreenChanged);

		sendRequest(ScreenMsg.GET_SELECTED_SCREEN, new RequestMessage(selectedScreenLoaded));
		sendRequest(ScreenMsg.GET_SCREEN_INFO_LIST, new RequestMessage(showScreenInfoList));

		view.screenList.addEventListener(SelectableDataGroup.SELECTED, screenListItemSelectedHandler);
	}

	private function showScreenInfoList(op:IAsyncOperation):void {
		var screenInfos:Array = op.result as Array;
		view.screenListProvider = new ArrayCollection(screenInfos);
		view.screenList.selectedIndex = 0;
	}

	private function selectedScreenChanged(screen:ScreenBase):void {
		showScreen(screen);
	}

	private function selectedScreenLoaded(op:IAsyncOperation):void {
		showScreen(op.result as ScreenBase);
	}

	private function showScreen(screen:ScreenBase):void {
		view.removeScreen();
		if (screen) {
			view.addScreen(screen);
		}
	}

	private function screenListItemSelectedHandler(event:Event):void {
		sendRequest(ScreenMsg.SELECT_SCREEN, new RequestMessage(null, view.screenList.selectedItem.id));
	}

	override protected function deactivate():void {
		throw new Error("Don't remove MainMediator, don't unregister MainView!");
	}

	private function startEditing(data:*):void {
		view.screenList.mouseEnabled = view.screenList.mouseChildren = false;
	}

	private function endEditing(data:*):void {
		view.screenList.mouseEnabled = view.screenList.mouseChildren = true;
	}

	private function lock(data:* = null):void {
		view.lock();
	}

	private function unlock(data:*):void {
		view.unlock();
	}

}
}