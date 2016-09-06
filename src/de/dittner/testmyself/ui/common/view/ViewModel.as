package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.ui.view.main.MainVM;
import de.dittner.walter.WalterProxy;

import flash.events.Event;

public class ViewModel extends WalterProxy {
	public function ViewModel() {
		super();
	}

	[Inject]
	public var mainVM:MainVM;

	[Inject]
	public var appModel:AppModel;

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

	//--------------------------------------
	//  viewTitle
	//--------------------------------------
	private var _viewTitle:String = "";
	[Bindable("viewTitleChanged")]
	public function get viewTitle():String {return _viewTitle;}
	public function set viewTitle(value:String):void {
		if (_viewTitle != value) {
			_viewTitle = value;
			dispatchEvent(new Event("viewTitleChanged"));
		}
	}

	override protected function activate():void {}

	public function viewActivated(viewID:String):void {
		isActive = true;
	}

	public function viewDeactivated():void {
		isActive = false;
	}

	public function lockView():void {
		if (mainVM) mainVM.viewLocked = true;
	}

	public function unlockView():void {
		if (mainVM) mainVM.viewLocked = false;
	}
}
}
