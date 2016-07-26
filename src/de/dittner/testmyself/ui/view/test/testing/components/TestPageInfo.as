package de.dittner.testmyself.ui.view.test.testing.components {
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTaskComplexity;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.events.Event;
import flash.events.EventDispatcher;

public class TestPageInfo extends EventDispatcher {
	public function TestPageInfo() {
		super();
	}

	//--------------------------------------
	//  pageNum
	//--------------------------------------
	private var _pageNum:uint = 0;
	[Bindable("pageNumChanged")]
	public function get pageNum():uint {return _pageNum;}
	public function set pageNum(value:uint):void {
		if (_pageNum != value) {
			_pageNum = value;
			dispatchEvent(new Event("pageNumChanged"));
		}
	}

	//--------------------------------------
	//  pageSize
	//--------------------------------------
	private var _pageSize:uint = 10;
	[Bindable("pageSizeChanged")]
	public function get pageSize():uint {return _pageSize;}
	public function set pageSize(value:uint):void {
		if (_pageSize != value) {
			_pageSize = value;
			dispatchEvent(new Event("pageSizeChanged"));
		}
	}

	//--------------------------------------
	//  amountAllTasks
	//--------------------------------------
	private var _amountAllTasks:int = -1;
	[Bindable("amountAllTasksChanged")]
	public function get amountAllTasks():int {return _amountAllTasks;}
	public function set amountAllTasks(value:int):void {
		if (_amountAllTasks != value) {
			_amountAllTasks = value;
			dispatchEvent(new Event("amountAllTasksChanged"));
		}
	}

	//--------------------------------------
	//  onlyFailedNotes
	//--------------------------------------
	private var _onlyFailedNotes:Boolean = false;
	[Bindable("onlyFailedNotesChanged")]
	public function get onlyFailedNotes():Boolean {return _onlyFailedNotes;}
	public function set onlyFailedNotes(value:Boolean):void {
		if (_onlyFailedNotes != value) {
			_onlyFailedNotes = value;
			dispatchEvent(new Event("onlyFailedNotesChanged"));
		}
	}

	//--------------------------------------
	//  tasks
	//--------------------------------------
	private var _tasks:Array;
	[Bindable("tasksChanged")]
	public function get tasks():Array {return _tasks;}
	public function set tasks(value:Array):void {
		if (_tasks != value) {
			_tasks = value;
			dispatchEvent(new Event("tasksChanged"));
		}
	}

	//--------------------------------------
	//  test
	//--------------------------------------
	private var _test:Test;
	[Bindable("testChanged")]
	public function get test():Test {return _test;}
	public function set test(value:Test):void {
		if (_test != value) {
			_test = value;
			dispatchEvent(new Event("testChanged"));
		}
	}

	//--------------------------------------
	//  selectedTaskComplexity
	//--------------------------------------
	private var _selectedTaskComplexity:uint = TestTaskComplexity.HIGH;
	[Bindable("selectedTaskComplexityChanged")]
	public function get selectedTaskComplexity():uint {return _selectedTaskComplexity;}
	public function set selectedTaskComplexity(value:uint):void {
		if (_selectedTaskComplexity != value) {
			_selectedTaskComplexity = value;
			dispatchEvent(new Event("selectedTaskComplexityChanged"));
		}
	}

	//--------------------------------------
	//  selectedTheme
	//--------------------------------------
	private var _selectedTheme:Theme;
	[Bindable("selectedThemeChanged")]
	public function get selectedTheme():Theme {return _selectedTheme;}
	public function set selectedTheme(value:Theme):void {
		if (_selectedTheme != value) {
			_selectedTheme = value;
			dispatchEvent(new Event("selectedThemeChanged"));
		}
	}

}
}
