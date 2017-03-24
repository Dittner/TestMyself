package de.dittner.testmyself.ui.common.menu {
import de.dittner.testmyself.ui.common.tileClasses.FadeTileButton;

import flash.events.Event;

public class MenuButton extends FadeTileButton {
	public function MenuButton() {
		super();
	}

	//--------------------------------------
	//  menuID
	//--------------------------------------
	private var _menuID:String = "";
	[Bindable("menuIDChanged")]
	public function get menuID():String {return _menuID;}
	public function set menuID(value:String):void {
		if (_menuID != value) {
			_menuID = value;
			dispatchEvent(new Event("menuIDChanged"));
		}
	}
}
}
