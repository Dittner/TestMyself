package dittner.testmyself.deutsch.view.common.audio.mp3 {
import dittner.testmyself.core.model.audioComment.AudioComment;
import dittner.testmyself.deutsch.view.common.audio.event.VoiceCommentEvent;

import flash.events.Event;
import flash.media.Sound;

import spark.components.supportClasses.SkinnableComponent;

[Event(name="removeCommentClick", type="dittner.testmyself.deutsch.view.common.audio.event.VoiceCommentEvent")]

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
	//  comment
	//--------------------------------------
	private var _comment:AudioComment;
	[Bindable("commentChanged")]
	public function get comment():AudioComment {return _comment;}
	public function set comment(value:AudioComment):void {
		if (_comment != value) {
			curState.stop();
			_comment = value;
			if (comment && comment.bytes) {
				comment.bytes.position = 0;
				playbackTime = 0;
				updateSound();
			}
			invalidateSkinState();
			dispatchEvent(new Event("commentChanged"));
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
		sound.loadCompressedDataFromByteArray(comment.bytes, comment.bytes.length);
		soundDuration = Math.ceil(sound.length / 1000);
	}

	public function play():void {
		if (comment) curState.play();
	}

	public function pause():void {
		curState.pause();
	}

	public function stop():void {
		curState.stop();
	}

	public function remove():void {
		stop();
		comment = null;
		dispatchEvent(new VoiceCommentEvent("removeCommentClick"));
	}

	public function clear():void {
		stop();
		comment = null;
	}

	override protected function getCurrentSkinState():String {
		if (!comment) return NORMAL;
		else if (curState == getPlayingState()) return PLAYING;
		else if (curState == getPausedState()) return PAUSED;
		return STOPPED;
	}
}
}
