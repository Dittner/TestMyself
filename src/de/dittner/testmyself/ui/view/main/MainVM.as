package de.dittner.testmyself.ui.view.main {

import de.dittner.testmyself.backend.LocalStorage;
import de.dittner.testmyself.ui.common.view.IViewFactory;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewNavigator;
import de.dittner.walter.WalterProxy;

import flash.events.Event;

public class MainVM extends WalterProxy {
	public function MainVM() {
		super();
	}

	private static const COMMENTS_BOARD_TEXT_KEY:String = "COMMENTS_BOARD_TEXT_KEY";

	[Bindable]
	[Inject]
	public var viewFactory:IViewFactory;

	[Bindable]
	[Inject]
	public var viewNavigator:ViewNavigator;

	//--------------------------------------
	//  selectedViewInfo
	//--------------------------------------
	private var _selectedViewInfo:ViewInfo;
	[Bindable("selectedViewInfoChanged")]
	public function get selectedViewInfo():ViewInfo {return _selectedViewInfo;}
	private function setSelectedViewInfo(value:ViewInfo):void {
		if (_selectedViewInfo != value) {
			_selectedViewInfo = value;
			dispatchEvent(new Event("selectedViewInfoChanged"));
		}
	}

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
	//  viewListLocked
	//--------------------------------------
	private var _viewListLocked:Boolean = false;
	[Bindable("viewListLockedChanged")]
	public function get viewListLocked():Boolean {return _viewListLocked;}
	public function set viewListLocked(value:Boolean):void {
		if (_viewListLocked != value) {
			_viewListLocked = value;
			dispatchEvent(new Event("viewListLockedChanged"));
		}
	}

	//--------------------------------------
	//  commentsBoardText
	//--------------------------------------
	private var _commentsBoardText:String = "Hier sind Ihre Notizen";
	[Bindable("commentsBoardTextChanged")]
	public function get commentsBoardText():String {return _commentsBoardText;}
	public function set commentsBoardText(value:String):void {
		if (_commentsBoardText != value) {
			_commentsBoardText = value;
			LocalStorage.write(COMMENTS_BOARD_TEXT_KEY, value || "");
			dispatchEvent(new Event("commentsBoardTextChanged"));
		}
	}

	override protected function activate():void {
		commentsBoardText = LocalStorage.read(COMMENTS_BOARD_TEXT_KEY) || _commentsBoardText;
	}

	override protected function deactivate():void {
		throw new Error("Don't remove MainVM, don't unregister MainVM!");
	}

}
}