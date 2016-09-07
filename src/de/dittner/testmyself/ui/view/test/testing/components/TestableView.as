package de.dittner.testmyself.ui.view.test.testing.components {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.ui.common.menu.IMenuBoard;
import de.dittner.testmyself.ui.common.menu.MenuBoardEvent;
import de.dittner.testmyself.ui.common.menu.MenuID;
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

	protected var actionCallback:Function;
	protected var menu:IMenuBoard;

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
	//  isActivating
	//--------------------------------------
	private var _isActivating:Boolean = false;
	[Bindable("isActivatingChanged")]
	public function get isActivating():Boolean {return _isActivating;}
	private function setIsActivating(value:Boolean):void {
		if (_isActivating != value) {
			_isActivating = value;
			dispatchEvent(new Event("isActivatingChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function activate(actionCallback:Function, menu:IMenuBoard):void {
		if (!isActivating) {
			setIsActivating(true);
			this.actionCallback = actionCallback;
			this.menu = menu;
			menu.addEventListener(MenuBoardEvent.CLICKED, menuClicked);
			menu.addEventListener("taskPriorityChanged", taskPriorityChanged);
			menu.showTestMenu();
		}
	}

	public function deactivate():void {
		if (isActivating) {
			setIsActivating(false);
			actionCallback = null;
			menu.removeEventListener(MenuBoardEvent.CLICKED, menuClicked);
			menu.removeEventListener("taskPriorityChanged", taskPriorityChanged);
			menu.hideTestMenu();
			menu = null;
			clear();
		}
	}

	private function taskPriorityChanged(e:Event):void {
		if (testTask) testTask.complexity = menu.taskPriority;
	}

	private function menuClicked(e:MenuBoardEvent):void {
		if (e.menuID == MenuID.TRUE) onTrueAnswered();
		else if (e.menuID == MenuID.FALSE) onFalseAnswered();
		else if (e.menuID == MenuID.ANSWER) showAnswer();
	}

	protected function onTrueAnswered():void {
		notifyTrueAnswer();
		requestNextTask();
	}

	protected function onFalseAnswered():void {
		notifyFalseAnswer();
		requestNextTask();
	}

	protected function showAnswer():void {
		showDetails = true
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (testTaskChanged && isActivating) {
			testTaskChanged = false;
			if (note) {
				if (note.hasAudio && note.audioComment.isEmpty) {
					var op:IAsyncOperation = note.loadAudioComment();
					op.addCompleteCallback(function (op:IAsyncOperation):void {
						audioCommentChanged();
					});
				}
				menu.taskPriority = testTask.complexity;
				updateForm();
			}
			else {
				clear();
			}
		}
	}

	protected function updateForm():void {}

	protected function clear():void {}

	protected function audioCommentChanged():void {}

	protected function requestNextTask():void {
		if (isActivating && actionCallback != null) actionCallback(TestingAction.NEXT_TASK);
	}

	protected function notifyTrueAnswer():void {
		if (isActivating && actionCallback != null) actionCallback(TestingAction.CORRECT_ANSWER);
	}

	protected function notifyFalseAnswer():void {
		if (isActivating && actionCallback != null) actionCallback(TestingAction.INCORRECT_ANSWER);
	}

}
}
