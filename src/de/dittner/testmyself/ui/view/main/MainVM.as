package de.dittner.testmyself.ui.view.main {

import de.dittner.testmyself.backend.LocalStorageKey;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.ui.common.view.ViewNavigator;
import de.dittner.walter.WalterProxy;
import de.dittner.walter.message.WalterMessage;

import flash.events.Event;

public class MainVM extends WalterProxy {
	public function MainVM() {
		super();
	}

	[Inject]
	public var viewNavigator:ViewNavigator;

	[Bindable]
	[Inject]
	public var appModel:AppModel;

	public var mainView:MainView;

	//--------------------------------------
	//  viewLocked
	//--------------------------------------
	private var _viewLocked:Boolean = false;
	[Bindable("viewLockedChanged")]
	public function get viewLocked():Boolean {return _viewLocked;}
	public function set viewLocked(value:Boolean):void {
		if (_viewLocked != value) {
			_viewLocked = value;
			dispatchEvent(new Event("viewLockedChanged"));
		}
	}

	//--------------------------------------
	//  commentsBoardText
	//--------------------------------------
	private var _commentsBoardText:String = "";
	[Bindable("commentsBoardTextChanged")]
	public function get commentsBoardText():String {return _commentsBoardText;}
	public function set commentsBoardText(value:String):void {
		if (_commentsBoardText != value) {
			_commentsBoardText = value;
			appModel.hash.write(LocalStorageKey.COMMENTS_BOARD_TEXT_KEY, value || "");
			dispatchEvent(new Event("commentsBoardTextChanged"));
		}
	}

	public function viewActivated(mainView:MainView):void {
		this.mainView = mainView;
		listenProxy(appModel, AppModel.HASH_CHANGED_MSG, updateCommentsBoardText);
		updateCommentsBoardText();
	}

	private function updateCommentsBoardText(msg:WalterMessage = null):void {
		commentsBoardText = appModel.hash.read(LocalStorageKey.COMMENTS_BOARD_TEXT_KEY) || "";
	}

	override protected function deactivate():void {
		throw new Error("Don't remove MainVM, don't unregister MainVM!");
	}

}
}