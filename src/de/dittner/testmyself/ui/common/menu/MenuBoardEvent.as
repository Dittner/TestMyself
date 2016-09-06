package de.dittner.testmyself.ui.common.menu {
import flash.events.Event;

public class MenuBoardEvent extends Event {

	public static const SELECTED:String = "selected";
	public static const CLICKED:String = "clicked";

	public function MenuBoardEvent(type:String, menuID:String) {
		super(type, true, false);
		_menuID = menuID;
	}

	private var _menuID:String = "";
	public function get menuID():String { return _menuID; }

	override public function clone():Event {
		return new MenuBoardEvent(type, menuID);
	}
}
}