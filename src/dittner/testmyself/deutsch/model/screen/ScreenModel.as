package dittner.testmyself.deutsch.model.screen {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.satelliteFlight.sf_namespace;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.service.screenFactory.IScreenFactory;
import dittner.testmyself.deutsch.service.screenFactory.ScreenID;
import dittner.testmyself.deutsch.service.screenMediatorFactory.IScreenMediatorFactory;
import dittner.testmyself.deutsch.view.common.screen.ScreenBase;

use namespace sf_namespace;

public class ScreenModel extends SFProxy {

	[Inject]
	public var screenFactory:IScreenFactory;

	[Inject]
	public var screenMediatorFactory:IScreenMediatorFactory;

	private var selectedMediator:SFMediator;

	//--------------------------------------
	//  selectedScreenID
	//--------------------------------------
	private var _selectedScreenID:String = "";
	public function get selectedScreenID():String {return _selectedScreenID;}
	public function set selectedScreenID(value:String):void {
		if (_selectedScreenID != value) {
			unregisterMediator();
			_selectedScreenID = value;
			selectedScreen = screenFactory.createScreen(selectedScreenID);
		}
	}

	//--------------------------------------
	//  selectedScreen
	//--------------------------------------
	private var _selectedScreen:ScreenBase;
	public function get selectedScreen():ScreenBase {return _selectedScreen;}
	public function set selectedScreen(value:ScreenBase):void {
		_selectedScreen = value;
		registerMediator();
		sendNotification(ScreenMsg.SELECTED_SCREEN_CHANGED_NOTIFICATION, selectedScreen);
	}

	//--------------------------------------
	//  locked
	//--------------------------------------
	private var _locked:Boolean = false;
	private function get locked():Boolean {return _locked;}
	private function set locked(value:Boolean):void {
		if (_locked != value) {
			_locked = value;
			sendNotification(locked ? ScreenMsg.LOCK_NOTIFICATION : ScreenMsg.UNLOCK_NOTIFICATION);
		}
	}

	//--------------------------------------
	//  editMode
	//--------------------------------------
	private var _editMode:Boolean = false;
	public function get editMode():Boolean {return _editMode;}
	public function set editMode(value:Boolean):void {
		if (_editMode != value) {
			_editMode = value;
			sendNotification(editMode ? ScreenMsg.START_EDIT_NOTIFICATION : ScreenMsg.END_EDIT_NOTIFICATION);
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private function registerMediator():void {
		var mediator:SFMediator = screenMediatorFactory.createScreenMediator(selectedScreenID);
		var moduleName:String = getModuleNameByScreen(selectedScreenID);
		module.registerMediatorTo(moduleName, selectedScreen, mediator);
		selectedMediator = mediator;
	}

	private function unregisterMediator():void {
		if (!selectedScreen) return;
		var moduleName:String = getModuleNameByScreen(selectedScreenID);
		module.unregisterMediatorFrom(moduleName, selectedMediator);
	}

	public function getModuleNameByScreen(screenID:String):String {
		var moduleName:String;
		switch (screenID) {
			case ScreenID.PHRASE :
				moduleName = ModuleName.PHRASE;
				break;
			case ScreenID.WORD :
				moduleName = ModuleName.WORD;
				break;
			case ScreenID.VERB :
				moduleName = ModuleName.VERB;
				break;
			case ScreenID.LESSON :
				moduleName = ModuleName.LESSON;
				break;
			default :
				moduleName = ModuleName.ROOT;
		}
		return moduleName;
	}

	private var lockRequestNum:int = 0;
	public function lockScreen():void {
		locked = true;
		lockRequestNum++;
	}

	public function unlockScreen():void {
		if (lockRequestNum > 0) lockRequestNum--;
		if (lockRequestNum == 0) locked = false;
	}

	override protected function activate():void {}

	override protected function deactivate():void {}

}
}