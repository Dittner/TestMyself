package de.dittner.testmyself.ui.common.view {
import de.dittner.async.utils.invalidateOf;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.ui.common.menu.IMenuBoard;
import de.dittner.testmyself.ui.view.main.IMainView;
import de.dittner.testmyself.ui.view.noteList.components.form.NoteForm;
import de.dittner.testmyself.ui.view.noteList.components.toolbar.NoteToolbar;

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
	//  mainView
	//--------------------------------------
	private var _mainView:IMainView;
	[Bindable("mainViewChanged")]
	public function get mainView():IMainView {return _mainView;}
	public function set mainView(value:IMainView):void {
		if (_mainView != value) {
			_mainView = value;
			dispatchEvent(new Event("mainViewChanged"));
		}
	}

	//--------------------------------------
	//  menu
	//--------------------------------------
	[Bindable("mainViewChanged")]
	public function get menu():IMenuBoard {return mainView.menu;}

	//--------------------------------------
	//  noteToolbar
	//--------------------------------------
	[Bindable("mainViewChanged")]
	public function get toolbar():NoteToolbar {return mainView.toolbar;}

	//--------------------------------------
	//  form
	//--------------------------------------
	[Bindable("mainViewChanged")]
	public function get form():NoteForm {return mainView.form;}

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
					invalidateOf(startActivation);
				break;
			case NavigationPhase.VIEW_REMOVE:
				_isActive = false;
				isActivateWaiting = false;
				CLog.info(LogTag.UI, "View: " + fullName + " is deactivated");
				dispatchEvent(new Event("isActiveChange"));
				AudioComment.PLAYER.stop();
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
			CLog.info(LogTag.UI, "View: " + fullName + " is activated");
			dispatchEvent(new Event("isActiveChange"));
			activate();
		}
	}

}
}
