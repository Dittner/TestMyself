package dittner.testmyself.view.main {

import dittner.testmyself.message.ViewMsg;
import dittner.testmyself.view.common.SelectableDataGroup;
import dittner.testmyself.view.core.ViewBase;

import flash.events.Event;

import mvcexpress.mvc.Mediator;

import mx.collections.ArrayCollection;

public class MainViewMediator extends Mediator {

	[Inject]
	public var mainView:MainView;

	private var curView:ViewBase;

	override protected function onRegister():void {
		mainView.viewList.addEventListener(SelectableDataGroup.SELECTED, selectedViewChangedHandler);
		addHandler(ViewMsg.ON_SELECTED_VIEW, showSelectedView);
		addHandler(ViewMsg.ON_ALL_VIEW_INFOS, showViewListData);
		addHandler(ViewMsg.LOCK_VIEWS, lock);
		addHandler(ViewMsg.UNLOCK_VIEWS, unlock);
		sendMessage(ViewMsg.GET_SELECTED_VIEW);
		sendMessage(ViewMsg.GET_ALL_VIEW_INFOS);
	}

	private function selectedViewChangedHandler(event:Event):void {
		sendMessage(ViewMsg.GET_SELECTED_VIEW, mainView.viewList.selectedItem);
	}

	override protected function onRemove():void {
		throw new Error("Don't remove MainMediator, don't unmediate MainView!");
	}

	private function showSelectedView(view:ViewBase):void {
		if (curView && curView.info.id == view.info.id) return;

		if (curView) {
			mediatorMap.unmediate(curView);
			mainView.removeView();
		}

		view.percentHeight = 100;
		view.percentWidth = 100;
		mainView.addView(view);
		mediatorMap.mediate(view);

		curView = view;
		mainView.selectedViewInfo = curView.info;
	}

	private function showViewListData(viewInfos:Array):void {
		mainView.viewListProvider = new ArrayCollection(viewInfos);
	}

	private function lock(params:Object):void {
		mainView.lock();
	}

	private function unlock(params:Object):void {
		mainView.unlock();
	}

}
}