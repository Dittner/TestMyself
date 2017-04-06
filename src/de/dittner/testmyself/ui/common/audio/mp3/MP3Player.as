package de.dittner.testmyself.ui.common.audio.mp3 {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.ui.common.audio.event.VoiceCommentEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.media.Sound;

[Event(name="removeCommentClick", type="de.dittner.testmyself.ui.common.audio.event.VoiceCommentEvent")]

public class MP3Player extends EventDispatcher implements IPlayerContext {
	public function MP3Player() {
		super();
		if (_instance) throw Error('Singleton error in SimplePopup');
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
	//  instance
	//--------------------------------------
	private static var _instance:MP3Player;
	public static function get instance():MP3Player {
		if (!_instance) _instance = new MP3Player();
		return _instance;
	}

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
	private var _playbackTime:Number = 0;
	[Bindable("playbackTimeChanged")]
	public function get playbackTime():Number {return _playbackTime;}
	public function set playbackTime(value:Number):void {
		if (_playbackTime != value) {
			_playbackTime = value;
			curState.updatePlayingPosition();
			dispatchEvent(new Event("playbackTimeChanged"));
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
			if (_comment && _comment.hasBytes) {
				updateSound();
			}
			else if (_comment && _comment.isMp3) {
				sound = null;
				soundDuration = 0;
				_comment.loadMP3().addCompleteCallback(updateSound);
			}
			else {
				sound = null;
				soundDuration = 0;
			}
			dispatchEvent(new Event("commentChanged"));
		}
	}

	private function updateSound(op:IAsyncOperation = null):void {
		if (comment && comment.hasBytes) {
			var mp3Sound:Sound = new Sound();
			_comment.bytes.position = 0;
			mp3Sound.loadCompressedDataFromByteArray(comment.bytes, comment.bytes.length);
			sound = mp3Sound;
			soundDuration = Math.ceil(sound.length / 1000);
		}
	}

	//--------------------------------------
	//  sound
	//--------------------------------------
	private var _sound:Sound;
	[Bindable("soundChanged")]
	public function get sound():Sound {return _sound;}
	public function set sound(value:Sound):void {
		if (_sound != value) {
			_sound = value;
			dispatchEvent(new Event("soundChanged"));
		}
	}

	public function updatePlayback(sec:Number):void {
		_playbackTime = sec;
		dispatchEvent(new Event("playbackTimeChanged"));
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function getPlayingState():IPlayerState {return playingState;}
	public function getPausedState():IPlayerState {return pausedState;}
	public function getStoppedState():IPlayerState {return stoppedState;}

	public function play():void {
		curState.play();
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
