package de.dittner.testmyself.ui.common.menu {
import flash.events.Event;

public class NavigationMenuEvent extends Event {

	public static const SELECTED:String = "selected";
	public static const CLICKED:String = "clicked";

	public function NavigationMenuEvent(type:String, viewID:String) {
		super(type, true, false);
		_viewID = viewID;
	}

	private var _viewID:String = "";
	public function get viewID():String { return _viewID; }

	override public function clone():Event {
		return new NavigationMenuEvent(type, viewID);
	}
}
}