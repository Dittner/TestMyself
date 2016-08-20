package de.dittner.testmyself.ui.view.test.testing.components {
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.ui.view.test.common.TestingAction;

import flash.events.Event;

import spark.components.Group;

public class TestableView extends Group {
	public function TestableView() {
		super();
	}

	[Bindable]
	public var showDetails:Boolean = false;
	[Bindable]
	public var padding:uint = 0;
	[Bindable]
	public var actionCallback:Function;

	//--------------------------------------
	//  testTask
	//--------------------------------------
	protected var testTaskChanged:Boolean = false;
	private var _testTask:TestTask;
	[Bindable("testTaskChanged")]
	public function get testTask():TestTask {return _testTask;}
	public function set testTask(value:TestTask):void {
		if (_testTask != value) {
			_testTask = value;
			testTaskChanged = true;
			invalidateProperties();
			dispatchEvent(new Event("testTaskChanged"));
		}
	}

	//--------------------------------------
	//  note
	//--------------------------------------
	[Bindable("testTaskChanged")]
	public function get note():Note {return testTask ? testTask.note : null;}

	//--------------------------------------
	//  isProcessing
	//--------------------------------------
	private var _isProcessing:Boolean = false;
	[Bindable("isProcessingChanged")]
	public function get isProcessing():Boolean {return _isProcessing;}
	private function setIsProcessing(value:Boolean):void {
		if (_isProcessing != value) {
			_isProcessing = value;
			dispatchEvent(new Event("isProcessingChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function commitProperties():void {
		super.commitProperties();
		if (testTaskChanged && visible) {
			testTaskChanged = false;
			if (note) {
				updateForm();
				setIsProcessing(true);
			}
			else {
				clear();
				setIsProcessing(false);
			}
		}
	}

	protected function updateForm():void {}

	protected function clear():void {}

	protected function requestNextTask():void {
		if (isProcessing) actionCallback(TestingAction.NEXT_TASK);
	}

	protected function notifyTrueAnswer():void {
		if (isProcessing) actionCallback(TestingAction.CORRECT_ANSWER);
	}

	protected function notifyFalseAnswer():void {
		if (isProcessing) actionCallback(TestingAction.INCORRECT_ANSWER);
	}

	public function stop():void {
		setIsProcessing(false);
		clear();
	}

}
}
