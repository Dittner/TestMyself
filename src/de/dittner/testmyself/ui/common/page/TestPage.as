package de.dittner.testmyself.ui.common.page {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTask;

import flash.events.Event;

public class TestPage extends NotePage {
	public function TestPage() {
		super();
	}

	public var tasks:Array = [];

	//--------------------------------------
	//  loadOnlyFailedTestTask
	//--------------------------------------
	private var _loadOnlyFailedTestTask:Boolean = true;
	[Bindable("loadOnlyFailedTestTaskChanged")]
	public function get loadOnlyFailedTestTask():Boolean {return _loadOnlyFailedTestTask;}
	public function set loadOnlyFailedTestTask(value:Boolean):void {
		if (_loadOnlyFailedTestTask != value) {
			_loadOnlyFailedTestTask = value;
			dispatchEvent(new Event("loadOnlyFailedTestTaskChanged"));
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
	//  taskComplexity
	//--------------------------------------
	private var _taskComplexity:uint;
	[Bindable("taskComplexityChanged")]
	public function get taskComplexity():uint {return _taskComplexity;}
	public function set taskComplexity(value:uint):void {
		if (_taskComplexity != value) {
			_taskComplexity = value;
			dispatchEvent(new Event("taskComplexityChanged"));
		}
	}

	//--------------------------------------
	//  selectedNote
	//--------------------------------------
	[Bindable("noteChanged")]
	public function get selectedTask():TestTask {return getTask();}

	protected override function getNote():Note {
		var res:* = coll && coll.length > 0 && coll.length > selectedItemIndex ? coll[selectedItemIndex] : null;
		return res is TestTask ? (res as TestTask).note : res as Note;
	}

	public function getTask():TestTask {
		return coll && coll.length > 0 && coll.length > selectedItemIndex ? coll[selectedItemIndex] : null;
	}

	override public function load():IAsyncOperation {
		return storage.loadTestStatistics(this);
	}
}
}
