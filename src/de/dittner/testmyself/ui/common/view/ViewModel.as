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

	override protected function activate():void {}

	protected var viewInfo:ViewInfo;
	public function viewActivated(viewInfo:ViewInfo):void {
		this.viewInfo = viewInfo;
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

	public function goBack():void {
		if (mainVM) mainVM.viewNavigator.goBack();
	}

	public function navigateTo(viewInfo:ViewInfo):void {
		if (mainVM) mainVM.viewNavigator.navigate(viewInfo);
	}
}
}
