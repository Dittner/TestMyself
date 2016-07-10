package de.dittner.testmyself.ui.common.audio {
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.ui.common.audio.event.VoiceCommentEvent;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import spark.components.Button;
import spark.components.supportClasses.SkinnableComponent;
import spark.core.SpriteVisualElement;

//--------------------------------------
//  Events
//--------------------------------------

[Event(name="addCommentClick", type="de.dittner.testmyself.ui.common.audio.event.VoiceCommentEvent")]

[Event(name="removeCommentClick", type="de.dittner.testmyself.ui.common.audio.event.VoiceCommentEvent")]

//--------------------------------------
//  Skin States
//--------------------------------------

[SkinState("normal")]
[SkinState("recording")]
[SkinState("recorded")]
[SkinState("playing")]

//----------------------------------------------------------------------------------------------
//
//  Class
//
//----------------------------------------------------------------------------------------------

public class RawDataPlayer extends SkinnableComponent {

	//----------------------------------------------------------------------------------------------
	//
	//  Const
	//
	//----------------------------------------------------------------------------------------------

	private static const NORMAL:String = "normal";
	private static const RECORDING:String = "recording";
	private static const RECORDED:String = "recorded";
	private static const PLAYING:String = "playing";

	//----------------------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//----------------------------------------------------------------------------------------------

	public function RawDataPlayer() {
		recordingTimer = new Timer(maxRecordSize * 60 * 1000, 1);
		recordingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, recordingTimeComplete);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	private var animation:MovieClip;
	public var maxRecordSize:Number = 0.2;//min
	private var recordingTimer:Timer;

	//--------------------------------------------------------------------------
	//
	//  Skin parts
	//
	//--------------------------------------------------------------------------

	[SkinPart(required="false")]
	public var recordBtn:Button;

	[SkinPart(required="false")]
	public var stopBtn:Button;

	[SkinPart(required="false")]
	public var playBtn:Button;

	[SkinPart(required="false")]
	public var pauseBtn:Button;

	[SkinPart(required="false")]
	public var removeRecordBtn:Button;

	[SkinPart(required="false")]
	public var recordingAnimation:SpriteVisualElement;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	[Bindable]
	public var recorder:VoiceRecorder = new VoiceRecorder();

	[Bindable]
	public var recording:Boolean = false;

	//--------------------------------------
	//  comment
	//--------------------------------------
	protected var _comment:AudioComment;
	[Bindable("commentChanged")]
	public function get comment():AudioComment {return _comment;}
	public function set comment(value:AudioComment):void {
		if (_comment != value) {
			_comment = value;
			if (comment && comment.bytes) {
				recorder.stopRecording();
				recorder.pause();
				recorder.recordedBytes = comment.bytes;
				internalState = "recorded";
			}
			else {
				internalState = NORMAL;
			}
			dispatchEvent(new Event("commentChanged"));
		}
	}

	private var _internalState:String;
	private var internalStateChanged:Boolean = false;
	public function get internalState():String {
		return _internalState;
	}

	public function set internalState(value:String):void {
		if (_internalState != value) {
			_internalState = value;
			internalStateChanged = true;
			invalidateSkinState();
		}

	}

	public function record():void {
		recorder.record();
		internalState = RECORDING;
		recordingTimer.stop();
		recordingTimer.reset();
		recordingTimer.delay = maxRecordSize * 60 * 1000;
		recordingTimer.start();
	}

	public function stopRecording():void {
		recordingTimer.stop();
		if (!recording) return;

		if (recorder.recordedBytes.length < 100000) {
			recorder.stopRecording();
			recorder.removeRecord();
			internalState = NORMAL;
		}
		else {
			recorder.stopRecording();
			dispatchEvent(new VoiceCommentEvent(VoiceCommentEvent.ADD_COMMENT_CLICK));
			internalState = RECORDED;
		}
	}

	public function stopPlaying():void {
		if (!recorder.playing) return;

		recorder.pause();
		recorder.playbackFramesPosition = 0;
		internalState = RECORDED;
	}

	public function removeRecord():void {
		recorder.removeRecord();
		dispatchEvent(new VoiceCommentEvent(VoiceCommentEvent.REMOVE_COMMENT_CLICK));
		internalState = NORMAL;
	}

	public function clear():void {
		stopRecording();
		stopPlaying();
		removeRecord();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Overridden Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance == recordBtn) {
			recordBtn.addEventListener(MouseEvent.CLICK, recordBtn_clickHandler)
		}
		else if (instance == stopBtn) {
			stopBtn.addEventListener(MouseEvent.CLICK, stopBtn_clickHandler);
		}
		else if (instance == playBtn) {
			playBtn.addEventListener(MouseEvent.CLICK, playBtn_clickHandler);
		}
		else if (instance == pauseBtn) {
			pauseBtn.addEventListener(MouseEvent.CLICK, pauseBtn_clickHandler);
		}
		else if (instance == removeRecordBtn) {
			removeRecordBtn.addEventListener(MouseEvent.CLICK, removeRecordBtn_clickHandler);
		}
		else if (instance == recordingAnimation) {
			animation = new BlackProgressbar();
			recordingAnimation.addChild(animation);
		}

	}

	override protected function partRemoved(partName:String, instance:Object):void {
		super.partRemoved(partName, instance);
	}

	override protected function commitProperties():void {
		super.commitProperties();

		if (internalStateChanged) {
			internalStateChanged = false;

			recording = internalState == RECORDING;
			if (animation) {
				internalState == RECORDING ? animation.play() : animation.stop();
			}

		}
	}

	override protected function getCurrentSkinState():String {
		if (internalState && internalState.length > 0) {
			return internalState;
		}
		return super.getCurrentSkinState();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Event Handlers
	//
	//----------------------------------------------------------------------------------------------

	private function recordBtn_clickHandler(event:MouseEvent):void {
		record();
	}

	private function stopBtn_clickHandler(event:MouseEvent):void {
		stopRecording();
	}

	private function playBtn_clickHandler(event:MouseEvent):void {
		recorder.addEventListener(VoiceRecorderEvent.PLAYBACK_FINISHED, playbackFinished);
		recorder.play();
		internalState = PLAYING;
	}

	private function playbackFinished(event:Event):void {
		recorder.playbackFramesPosition = 0;
		internalState = RECORDED;
	}

	private function removeRecordBtn_clickHandler(event:MouseEvent):void {
		removeRecord();
	}

	private function pauseBtn_clickHandler(event:MouseEvent):void {
		recorder.pause();
		internalState = RECORDED;
	}

	private function recordingTimeComplete(event:TimerEvent):void {
		stopRecording();
	}
}
}
