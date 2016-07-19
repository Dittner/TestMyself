package de.dittner.testmyself.model.screen {
import de.dittner.testmyself.ui.common.view.IScreenMediatorFactory;
import de.dittner.testmyself.ui.common.view.IViewFactory;
import de.dittner.testmyself.ui.common.view.ViewID;
import de.dittner.testmyself.ui.message.ScreenMsg;

use namespace sf_namespace;

public class ScreenModel extends SFProxy {

	[Inject]
	public var screenFactory:IViewFactory;

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
			selectedScreen = screenFactory.createView(selectedScreenID);
		}
	}

	//--------------------------------------
	//  selectedScreen
	//--------------------------------------
	private var _selectedScreen:ViewBaseOLD;
	public function get selectedScreen():ViewBaseOLD {return _selectedScreen;}
	public function set selectedScreen(value:ViewBaseOLD):void {
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
		if (locked != value) {
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
			case ViewID.WORD :
				moduleName = ModuleName.WORD;
				break;
			case ViewID.VERB :
				moduleName = ModuleName.VERB;
				break;
			case ViewID.LESSON :
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