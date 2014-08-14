package dittner.testmyself.view.common.audio.mp3 {
import dittner.testmyself.view.common.audio.event.VoiceCommentEvent;

import flash.events.Event;
import flash.media.Sound;
import flash.utils.ByteArray;

import spark.components.supportClasses.SkinnableComponent;

[Event(name="removeCommentClick", type="dittner.testmyself.view.common.audio.event.VoiceCommentEvent")]

public class MP3Player extends SkinnableComponent implements IPlayerContext {
	private static const NORMAL:String = "normal";
	private static const PLAYING:String = "playing";
	private static const PAUSED:String = "paused";
	private static const STOPPED:String = "stopped";

	public function MP3Player() {
		super();

		playingState = new PlayingState(this);
		pausedState = new PausedState(this);
		stoppedState = new StoppedState(this);

		curState = stoppedState;
	}

	private var playingState:IPlayerState;
	private var pausedState:IPlayerState;
	private var stoppedState:IPlayerState;

	//--------------------------------------
	//  audioComment
	//--------------------------------------
	private var _audioComment:ByteArray;
	[Bindable("audioCommentChanged")]
	public function get audioComment():ByteArray {return _audioComment;}
	public function set audioComment(value:ByteArray):void {
		if (_audioComment != value) {
			curState.stop();
			_audioComment = value;
			if (audioComment) {
				audioComment.position = 0;
				updateSound();
			}
			invalidateSkinState();
			dispatchEvent(new Event("audioCommentChanged"));
		}
	}

	//--------------------------------------
	//  curState
	//--------------------------------------
	private var _curState:IPlayerState;
	[Bindable("curStateChanged")]
	public function get curState():IPlayerState {return _curState;}
	public function set curState(value:IPlayerState):void {
		if (_curState != value) {
			_curState = value;
			invalidateSkinState();
			dispatchEvent(new Event("curStateChanged"));
		}
	}

	//--------------------------------------
	//  removeEnabled
	//--------------------------------------
	private var _removeRecordEnabled:Boolean = true;
	[Bindable("removeEnabledChanged")]
	public function get removeRecordEnabled():Boolean {return _removeRecordEnabled;}
	public function set removeRecordEnabled(value:Boolean):void {
		if (_removeRecordEnabled != value) {
			_removeRecordEnabled = value;
			dispatchEvent(new Event("removeEnabledChanged"));
		}
	}

	public function getPlayingState():IPlayerState {return playingState;}
	public function getPausedState():IPlayerState {return pausedState;}
	public function getStoppedState():IPlayerState {return stoppedState;}

	//--------------------------------------
	//  soundDuration in sec
	//--------------------------------------
	private var _soundDuration:int = 0;
	[Bindable("soundDurationChanged")]
	public function get soundDuration():int {return _soundDuration;}
	public function set soundDuration(value:int):void {
		if (_soundDuration != value) {
			_soundDuration = value;
			dispatchEvent(new Event("soundDurationChanged"));
		}
	}

	//--------------------------------------
	//  playbackTime
	//--------------------------------------
	private var _playbackTime:int = 0;
	[Bindable("playbackTimeChanged")]
	public function get playbackTime():int {return _playbackTime;}
	public function set playbackTime(value:int):void {
		if (_playbackTime != value) {
			_playbackTime = value;
			curState.updatePlayingPosition();
			dispatchEvent(new Event("playbackTimeChanged"));
		}
	}

	public function updatePlayback(sec:int):void {
		_playbackTime = sec;
		dispatchEvent(new Event("playbackTimeChanged"));
	}

	private var _sound:Sound = new Sound();
	public function get sound():Sound {
		return _sound;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private function updateSound():void {
		_sound = new Sound();
		sound.loadCompressedDataFromByteArray(audioComment, audioComment.length);
		soundDuration = Math.ceil(sound.length / 1000);
	}

	public function play():void {
		if (audioComment) curState.play();
	}

	public function pause():void {
		curState.pause();
	}

	public function stop():void {
		curState.stop();
	}

	public function remove():void {
		stop();
		audioComment = null;
		dispatchEvent(new VoiceCommentEvent("removeCommentClick"));
	}

	public function clear():void {
		stop();
		audioComment = null;
	}

	override protected function getCurrentSkinState():String {
		if (!audioComment) return NORMAL;
		else if (curState == getPlayingState()) return PLAYING;
		else if (curState == getPausedState()) return PAUSED;
		return STOPPED;
	}
}
}
