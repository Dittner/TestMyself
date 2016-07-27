package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.ui.view.main.MainVM;
import de.dittner.walter.WalterProxy;

import flash.events.Event;

public class ViewModel extends WalterProxy {
	public function ViewModel() {
		super();
	}

	[Inject]
	public var mainVM:MainVM;

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

	public function lockViewList():void {
		if (mainVM) mainVM.viewListLocked = true;
	}

	public function unlockViewList():void {
		if (mainVM) mainVM.viewListLocked = false;
	}
}
}
