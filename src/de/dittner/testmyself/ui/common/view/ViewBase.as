package de.dittner.testmyself.ui.common.view {
import de.dittner.async.utils.doLaterInFrames;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.ui.common.menu.IMenuBoard;
import de.dittner.testmyself.ui.common.utils.AppSizes;

import flash.events.Event;
import flash.utils.getQualifiedClassName;

import mx.core.mx_internal;
import mx.events.FlexEvent;

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
		addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	protected var fullName:String;
	protected var isActivateWaiting:Boolean = false;

	public var data:Object;
	public const HEADER_HEI:int = AppSizes.SCREEN_HEADER_HEIGHT;
	public const FOOTER_HEI:int = AppSizes.SCREEN_FOOTER_HEIGHT;
	public const PADDING:uint = 20;

	//--------------------------------------
	//  viewID
	//--------------------------------------
	private var _viewID:String = "";
	[Bindable("viewIDChanged")]
	public function get viewID():String {return _viewID;}
	public function set viewID(value:String):void {
		if (_viewID != value) {
			_viewID = value;
			dispatchEvent(new Event("viewIDChanged"));
		}
	}

	//--------------------------------------
	//  menu
	//--------------------------------------
	private var _menu:IMenuBoard;
	[Bindable("menuChanged")]
	public function get menu():IMenuBoard {return _menu;}
	public function set menu(value:IMenuBoard):void {
		if (_menu != value) {
			_menu = value;
			dispatchEvent(new Event("menuChanged"));
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
	protected function activating():void {}
	protected function activate():void {}
	protected function deactivate():void {}
	protected function destroy():void {}

	/*
	 * invoke by navigator
	 * */

	internal function invalidate(navigationPhase:String):void {
		switch (navigationPhase) {
			case NavigationPhase.VIEW_ACTIVATE:
				activating();
				isActivateWaiting = true;
				if (initialized)
					doLaterInFrames(startActivation, 20);
				break;
			case NavigationPhase.VIEW_REMOVE:
				_isActive = false;
				isActivateWaiting = false;
				CLog.info(LogCategory.UI, "View: " + fullName + " is deactivated");
				dispatchEvent(new Event("isActiveChange"));
				deactivate();
				break;
		}
	}

	protected function creationCompleteHandler(event:FlexEvent):void {
		if (isActivateWaiting) startActivation();
	}

	private function startActivation():void {
		if (isActivateWaiting) {
			isActivateWaiting = false;
			_isActive = true;
			CLog.info(LogCategory.UI, "View: " + fullName + " is activated");
			dispatchEvent(new Event("isActiveChange"));
			activate();
		}
	}

}
}
