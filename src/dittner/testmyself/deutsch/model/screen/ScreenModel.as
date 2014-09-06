package dittner.testmyself.deutsch.model.screen {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.module.RootModule;
import dittner.satelliteFlight.module.SFModule;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.satelliteFlight.utils.SFException;
import dittner.satelliteFlight.utils.SFExceptionMsg;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.service.screenFactory.IScreenFactory;
import dittner.testmyself.deutsch.service.screenFactory.ScreenId;
import dittner.testmyself.deutsch.service.screenMediatorFactory.IScreenMediatorFactory;
import dittner.testmyself.deutsch.view.common.screen.ScreenBase;

public class ScreenModel extends SFProxy {

	[Inject]
	public var screenFactory:IScreenFactory;

	[Inject]
	public var screenMediatorFactory:IScreenMediatorFactory;

	[Inject]
	public var rootModule:RootModule;

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

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private function registerMediator():void {
		var mediator:SFMediator = screenMediatorFactory.createScreenMediator(selectedScreenID);
		var moduleName:String = getModuleNameByScreen(selectedScreenID);
		var module:SFModule = rootModule.getModule(moduleName);

		if (!module) throw new SFException(SFExceptionMsg.MODULE_NOT_FOUND + "; module name: " + moduleName);

		module.registerMediator(selectedScreen, mediator);
		selectedMediator = mediator;
	}

	private function unregisterMediator():void {
		if (!selectedScreen) return;
		var moduleName:String = getModuleNameByScreen(selectedScreenID);
		var module:SFModule = rootModule.getModule(moduleName);

		if (!module) throw new SFException(SFExceptionMsg.MODULE_NOT_FOUND);

		module.unregisterMediator(selectedMediator);
	}

	public function getModuleNameByScreen(screenID:String):String {
		var moduleName:String;
		switch (screenID) {
			case ScreenId.PHRASE :
				moduleName = ModuleName.PHRASE;
				break;
			case ScreenId.WORD :
				moduleName = ModuleName.WORD;
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