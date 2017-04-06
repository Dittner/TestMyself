package de.dittner.testmyself.ui.view.test.testing.components {
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.ui.common.audio.mp3.MP3Player;
import de.dittner.testmyself.ui.common.menu.IActionMenu;
import de.dittner.testmyself.ui.common.menu.NavigationMenuEvent;
import de.dittner.testmyself.ui.common.menu.ToolAction;
import de.dittner.testmyself.ui.common.menu.ToolActionEvent;
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
	protected var actionMenu:IActionMenu;

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

	public function activate(actionCallback:Function, actionMenu:IActionMenu):void {
		if (!isActivating) {
			setIsActivating(true);
			this.actionCallback = actionCallback;
			this.actionMenu = actionMenu;
			actionMenu.addEventListener(ToolActionEvent.SELECTED, actionSelected);
			actionMenu.addEventListener("taskPriorityChanged", taskPriorityChanged);
			showTestMenu();
		}
	}

	protected function showTestMenu():void {
		actionMenu.showTestMenu();
	}

	public function deactivate():void {
		if (isActivating) {
			setIsActivating(false);
			actionCallback = null;
			actionMenu.removeEventListener(NavigationMenuEvent.CLICKED, actionSelected);
			actionMenu.removeEventListener("taskPriorityChanged", taskPriorityChanged);
			actionMenu.showPrevMenu();
			actionMenu = null;
			clear();
		}
	}

	private function taskPriorityChanged(e:Event):void {
		if (testTask) testTask.complexity = actionMenu.taskPriority;
	}

	private function actionSelected(e:ToolActionEvent):void {
		if (e.actionID == ToolAction.TRUE) onTrueAnswered();
		else if (e.actionID == ToolAction.FALSE) onFalseAnswered();
		else if (e.actionID == ToolAction.ANSWER) showAnswer();
		else if (e.actionID == ToolAction.NEXT_TASK) requestNextTask();
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
				actionMenu.taskPriority = testTask.complexity;
				updateForm();
			}
			else {
				clear();
			}
		}
	}

	protected function updateForm():void {}

	protected function clear():void {}

	protected function playAudioComment():void {
		if (note && note.hasAudio) {
			MP3Player.instance.comment = note.audioComment;
			MP3Player.instance.play();
		}
	}

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
