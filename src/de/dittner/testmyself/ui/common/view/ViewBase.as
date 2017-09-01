package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.ui.common.audio.mp3.MP3Player;
import de.dittner.testmyself.ui.common.menu.IActionMenu;
import de.dittner.testmyself.ui.common.menu.INavigationMenu;
import de.dittner.testmyself.ui.common.menu.INoteToolbar;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.view.main.IMainView;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.events.Event;
import flash.utils.getQualifiedClassName;

import mx.core.mx_internal;

import spark.components.SkinnableContainer;

use namespace mx_internal;

public class ViewBase extends SkinnableContainer {

	public const PADDING:uint = Values.PT15;

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
	public var cacheable:Boolean = true;

	//--------------------------------------
	//  isBgShown
	//--------------------------------------
	private var _isBgShown:Boolean = true;
	[Bindable("isBgShownChanged")]
	public function get isBgShown():Boolean {return _isBgShown;}
	public function set isBgShown(value:Boolean):void {
		if (_isBgShown != value) {
			_isBgShown = value;
			invalidateDisplayList();
			dispatchEvent(new Event("isBgShownChanged"));
		}
	}

	//--------------------------------------
	//  viewInfo
	//--------------------------------------
	private var _viewInfo:ViewInfo;
	[Bindable("viewInfoChanged")]
	public function get viewInfo():ViewInfo {return _viewInfo;}
	public function set viewInfo(value:ViewInfo):void {
		if (_viewInfo != value) {
			_viewInfo = value;
			dispatchEvent(new Event("viewInfoChanged"));
		}
	}

	//--------------------------------------
	//  mainView
	//--------------------------------------
	private var _mainView:IMainView;
	[Bindable("mainViewChanged")]
	public function get mainView():IMainView {return _mainView;}
	public function set mainView(value:IMainView):void {
		if (_mainView != value) {
			if (mainView) mainView.removeEventListener("appBgColorChanged", appBgColorChanged);
			_mainView = value;
			if (mainView) mainView.addEventListener("appBgColorChanged", appBgColorChanged);
			dispatchEvent(new Event("mainViewChanged"));
		}
	}

	private function appBgColorChanged(e:Event):void {
		invalidateDisplayList();
	}

	//--------------------------------------
	//  actionMenu
	//--------------------------------------
	[Bindable("mainViewChanged")]
	public function get navigationMenu():INavigationMenu {return mainView.navigationMenu;}

	//--------------------------------------
	//  actionMenu
	//--------------------------------------
	[Bindable("mainViewChanged")]
	public function get actionMenu():IActionMenu {return mainView.actionMenu;}

	//--------------------------------------
	//  noteToolbar
	//--------------------------------------
	[Bindable("mainViewChanged")]
	public function get toolbar():INoteToolbar {return mainView.toolbar;}

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

	private var _isActivating:Boolean = false;
	[Bindable("isActivatingChange")]
	public function get isActivating():Boolean {return _isActivating;}

	protected var _isRemoving:Boolean = false;
	[Bindable("isRemovingChange")]
	public function get isRemoving():Boolean {return _isRemoving;}

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
	protected function deactivating():void {}
	protected function deactivate():void {}
	protected function destroy():void {}

	/*
	 * invoke by navigator
	 * */
	internal function invalidate(navigationPhase:String):void {
		switch (navigationPhase) {
			case NavigationPhase.VIEW_ACTIVATING:
				_isActivating = true;
				dispatchEvent(new Event("isActivatingChange"));
				activating();
				break;
			case NavigationPhase.VIEW_ACTIVATE:
				_isActivating = false;
				CLog.info(LogTag.UI, "View: " + fullName + " is activated");
				dispatchEvent(new Event("isActivatingChange"));
				_isActive = true;
				dispatchEvent(new Event("isActiveChange"));
				activate();
				break;
			case NavigationPhase.VIEW_REMOVING:
				if (stage) stage.focus = null;
				_isRemoving = true;
				dispatchEvent(new Event("isRemovingChange"));
				_isActive = false;
				dispatchEvent(new Event("isActiveChange"));
				MP3Player.instance.stop();
				deactivating();
				break;
			case NavigationPhase.VIEW_REMOVE:
				_isRemoving = false;
				_isRemoving = true;
				CLog.info(LogTag.UI, "View: " + fullName + " is deactivated");
				dispatchEvent(new Event("isRemovingChange"));
				deactivate();
				if (!cacheable) destroy();
				break;
		}
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		if (isBgShown) {
			g.beginFill(mainView ? mainView.appBgColor : AppColors.APP_BG_WHITE);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
	}

}
}
