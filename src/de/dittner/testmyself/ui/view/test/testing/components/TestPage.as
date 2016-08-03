package de.dittner.testmyself.ui.view.test.testing.components {
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;

public class TestPage extends EventDispatcher {
	public function TestPage() {
		super();
	}

	//--------------------------------------
	//  number
	//--------------------------------------
	private var _number:uint = 0;
	[Bindable("numberChanged")]
	public function get number():uint {return _number;}
	public function set number(value:uint):void {
		if (_number != value) {
			_number = value;
			dispatchEvent(new Event("numberChanged"));
		}
	}

	//--------------------------------------
	//  size
	//--------------------------------------
	private var _size:uint = 10;
	[Bindable("sizeChanged")]
	public function get size():uint {return _size;}
	public function set size(value:uint):void {
		if (_size != value) {
			_size = value;
			dispatchEvent(new Event("sizeChanged"));
		}
	}

	//--------------------------------------
	//  amountAllTasks
	//--------------------------------------
	private var _amountAllTasks:int = 0;
	[Bindable("amountAllTasksChanged")]
	public function get amountAllTasks():int {return _amountAllTasks;}
	public function set amountAllTasks(value:int):void {
		if (_amountAllTasks != value) {
			_amountAllTasks = value;
			dispatchEvent(new Event("amountAllTasksChanged"));
		}
	}

	//--------------------------------------
	//  countAllNotes
	//--------------------------------------
	private var _countAllNotes:Boolean = true;
	[Bindable("countAllNotesChanged")]
	public function get countAllNotes():Boolean {return _countAllNotes;}
	public function set countAllNotes(value:Boolean):void {
		if (_countAllNotes != value) {
			_countAllNotes = value;
			dispatchEvent(new Event("countAllNotesChanged"));
		}
	}

	//--------------------------------------
	//  loadOnlyFailedTestTask
	//--------------------------------------
	private var _loadOnlyFailedTestTask:Boolean = false;
	[Bindable("loadOnlyFailedTestTaskChanged")]
	public function get loadOnlyFailedTestTask():Boolean {return _loadOnlyFailedTestTask;}
	public function set loadOnlyFailedTestTask(value:Boolean):void {
		if (_loadOnlyFailedTestTask != value) {
			_loadOnlyFailedTestTask = value;
			dispatchEvent(new Event("loadOnlyFailedTestTaskChanged"));
		}
	}

	//--------------------------------------
	//  taskColl
	//--------------------------------------
	public var tasks:Array;
	private var _taskColl:ArrayCollection;
	[Bindable("taskCollChanged")]
	public function get taskColl():ArrayCollection {return _taskColl;}
	public function set taskColl(value:ArrayCollection):void {
		if (_taskColl != value) {
			_taskColl = value;
			dispatchEvent(new Event("taskCollChanged"));
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
	//  filter
	//--------------------------------------
	private var _filter:Theme;
	[Bindable("filterChanged")]
	public function get filter():Theme {return _filter;}
	public function set filter(value:Theme):void {
		if (_filter != value) {
			_filter = value;
			dispatchEvent(new Event("filterChanged"));
		}
	}

}
}
