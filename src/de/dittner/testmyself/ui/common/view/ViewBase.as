package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.ui.common.utils.AppSizes;

import flash.events.Event;
import flash.utils.getQualifiedClassName;

import mx.core.mx_internal;

import spark.components.SkinnableContainer;

use namespace mx_internal;

public class ViewBase extends SkinnableContainer {

	//----------------------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//----------------------------------------------------------------------------------------------

	public function ViewBase() {
		super();
		fullName = getQualifiedClassName(this);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	protected var fullName:String;
	public var data:Object;
	public const HEADER_HEI:int = AppSizes.SCREEN_HEADER_HEIGHT;
	public const FOOTER_HEI:int = AppSizes.SCREEN_FOOTER_HEIGHT;
	public const PADDING:uint = 20;

	//--------------------------------------
	//  info
	//--------------------------------------
	private var _info:ViewInfo;
	[Bindable("infoChanged")]
	public function get info():ViewInfo {return _info;}
	public function set info(value:ViewInfo):void {
		if (_info != value) {
			_info = value;
			dispatchEvent(new Event("infoChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	private var _isActive:Boolean = false;
	[Bindable("isActiveChange")]
	public function get isActive():Boolean {return _isActive;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	/*
	 *  Life cycle abstract methods
	 * */
	protected function activate():void {}
	protected function deactivate():void {}
	protected function destroy():void {}

	/*
	 * invoke by navigator
	 * */
	internal function invalidate(navigationPhase:String):void {
		switch (navigationPhase) {
			case NavigationPhase.VIEW_ACTIVATE:
				_isActive = true;
				CLog.info(LogCategory.UI, "View: " + fullName + " is activated");
				dispatchEvent(new Event("isActiveChange"));
				activate();
				break;
			case NavigationPhase.VIEW_REMOVE:
				_isActive = false;
				CLog.info(LogCategory.UI, "View: " + fullName + " is deactivated");
				dispatchEvent(new Event("isActiveChange"));
				deactivate();
				break;
		}
	}

}
}
