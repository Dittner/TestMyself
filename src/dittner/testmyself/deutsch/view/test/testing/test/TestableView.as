package dittner.testmyself.deutsch.view.test.testing.test {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.view.common.audio.utils.PlayerUtils;
import dittner.testmyself.deutsch.view.test.common.TestingAction;

import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;

import spark.components.Group;

public class TestableView extends Group implements ITestableView {
	public function TestableView() {
		super();
		timer = new Timer(1000);
		timer.addEventListener(TimerEvent.TIMER, timerHandler);
	}

	protected var timer:Timer;
	private var duration:Number = 0;//sec
	protected function timerHandler(event:TimerEvent):void {
		if (answerEnabled) {
			duration++;
			durationLbl = PlayerUtils.convertToHHMMSS(duration);
		}
	}

	[Bindable]
	public var durationLbl:String = "";
	[Bindable]
	public var title:String = "";
	[Bindable]
	public var showDetails:Boolean = false;
	[Bindable]
	public var padding:uint = 0;
	[Bindable]
	public var errorsNum:uint = 0;

	//--------------------------------------
	//  activeNote
	//--------------------------------------
	protected var activeNoteChanged:Boolean = false;
	private var _activeNote:INote;
	[Bindable("activeNoteChanged")]
	public function get activeNote():INote {return _activeNote;}
	public function set activeNote(value:INote):void {
		if (_activeNote != value) {
			_activeNote = value;
			activeNoteChanged = true;
			invalidateProperties();
			dispatchEvent(new Event("activeNoteChanged"));
		}
	}

	//--------------------------------------
	//  activeNoteExampleColl
	//--------------------------------------
	private var _activeNoteExampleColl:ArrayCollection;
	[Bindable("activeNoteExampleCollChanged")]
	public function get activeNoteExampleColl():ArrayCollection {return _activeNoteExampleColl;}
	public function set activeNoteExampleColl(value:ArrayCollection):void {
		if (_activeNoteExampleColl != value) {
			_activeNoteExampleColl = value;
			dispatchEvent(new Event("activeNoteExampleCollChanged"));
		}
	}

	//--------------------------------------
	//  totalTask
	//--------------------------------------
	private var _totalTask:int = 0;
	[Bindable("totalTaskChanged")]
	public function get totalTask():int {return _totalTask;}
	public function set totalTask(value:int):void {
		if (_totalTask != value) {
			_totalTask = value;
			dispatchEvent(new Event("totalTaskChanged"));
		}
	}

	//--------------------------------------
	//  taskNumber
	//--------------------------------------
	private var _taskNumber:int = 0;
	[Bindable("taskNumberChanged")]
	public function get taskNumber():int {return _taskNumber;}
	public function set taskNumber(value:int):void {
		if (_taskNumber != value) {
			_taskNumber = value;
			dispatchEvent(new Event("taskNumberChanged"));
		}
	}

	//--------------------------------------
	//  actionCallback
	//--------------------------------------
	private var _actionCallback:Function;
	[Bindable("actionCallbackChanged")]
	public function get actionCallback():Function {return _actionCallback;}
	public function set actionCallback(value:Function):void {
		if (_actionCallback != value) {
			_actionCallback = value;
			dispatchEvent(new Event("actionCallbackChanged"));
		}
	}

	//--------------------------------------
	//  answerEnabled
	//--------------------------------------
	private var _answerEnabled:Boolean = false;
	[Bindable("answerEnabledChanged")]
	public function get answerEnabled():Boolean {return _answerEnabled;}
	public function set answerEnabled(value:Boolean):void {
		if (_answerEnabled != value) {
			_answerEnabled = value;
			dispatchEvent(new Event("answerEnabledChanged"));
		}
	}

	public function start():void {
		duration = 0;
		errorsNum = 0;
		timer.start();
	}

	public function stop():void {
		timer.stop();
		clear();
	}

	protected function clear():void {}

	protected function goBack():void {
		if (actionCallback) actionCallback(TestingAction.ABORT_TEST);
	}

	protected function goNext():void {
		if (actionCallback) actionCallback(TestingAction.NEXT_TASK);
	}

}
}
