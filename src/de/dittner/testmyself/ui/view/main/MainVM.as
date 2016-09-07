package de.dittner.testmyself.ui.view.main {

import de.dittner.testmyself.backend.LocalStorage;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.ui.common.menu.IMenuBoard;
import de.dittner.testmyself.ui.common.menu.MenuBoard;
import de.dittner.testmyself.ui.common.view.ViewNavigator;
import de.dittner.walter.WalterProxy;

import flash.events.Event;

public class MainVM extends WalterProxy {
	public function MainVM() {
		super();
	}

	private static const COMMENTS_BOARD_TEXT_KEY:String = "COMMENTS_BOARD_TEXT_KEY";

	[Inject]
	public var viewNavigator:ViewNavigator;

	[Bindable]
	[Inject]
	public var appModel:AppModel;

	public var menu:IMenuBoard;

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
	private var _menuLocked:Boolean = false;
	[Bindable("viewListLockedChanged")]
	public function get menuLocked():Boolean {return _menuLocked;}
	public function set menuLocked(value:Boolean):void {
		if (_menuLocked != value) {
			_menuLocked = value;
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

	public function viewActivated(menu:MenuBoard):void {
		this.menu = menu;
		commentsBoardText = LocalStorage.read(COMMENTS_BOARD_TEXT_KEY) || _commentsBoardText;
	}

	override protected function deactivate():void {
		throw new Error("Don't remove MainVM, don't unregister MainVM!");
	}

}
}