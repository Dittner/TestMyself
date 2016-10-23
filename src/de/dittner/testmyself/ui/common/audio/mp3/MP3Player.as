package de.dittner.testmyself.ui.common.audio.mp3 {
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.ui.common.audio.event.VoiceCommentEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.media.Sound;

[Event(name="removeCommentClick", type="de.dittner.testmyself.ui.common.audio.event.VoiceCommentEvent")]

public class MP3Player extends EventDispatcher implements IPlayerContext {
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

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  hasComment
	//--------------------------------------
	[Bindable("commentChanged")]
	public function get hasComment():Boolean {return comment && comment.bytes;}

	//--------------------------------------
	//  comment
	//--------------------------------------
	private var _comment:AudioComment;
	[Bindable("commentChanged")]
	public function get comment():AudioComment {return _comment;}
	public function set comment(value:AudioComment):void {
		if (_comment != value) {
			stop();
			_comment = value;
			if (comment && comment.bytes) {
				comment.bytes.position = 0;
				playbackTime = 0;
				updateSound();
			}
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
			dispatchEvent(new Event("curStateChanged"));
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
		curState = stoppedState;
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

}
}
