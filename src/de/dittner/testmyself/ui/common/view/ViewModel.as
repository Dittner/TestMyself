package de.dittner.testmyself.ui.common.view {
import de.dittner.walter.WalterProxy;

import flash.events.Event;

public class ViewModel extends WalterProxy {
	public function ViewModel() {
		super();
	}

	//--------------------------------------
	//  isActive
	//--------------------------------------
	private var _isActive:Boolean = false;
	[Bindable("isActiveChanged")]
	public function get isActive():Boolean {return _isActive;}
	public function set isActive(value:Boolean):void {
		if (_isActive != value) {
			_isActive = value;
			dispatchEvent(new Event("isActiveChanged"));
		}
	}

	public function viewActivated(info:ViewInfo):void {
		isActive = true;
	}
	public function viewDeactivated():void {
		isActive = false;
	}
}
}
