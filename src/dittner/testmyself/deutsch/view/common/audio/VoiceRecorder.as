package dittner.testmyself.deutsch.view.common.audio {
import dittner.testmyself.deutsch.view.common.audio.utils.PlayerUtils;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.SampleDataEvent;
import flash.media.Microphone;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.utils.ByteArray;

[Event(type='dittner.testmyself.deutsch.view.common.audio.event.VoiceCommentEvent', name='playbackFinished')]
public class VoiceRecorder extends EventDispatcher {

	public function VoiceRecorder() {
		if (microphone == null) {
			microphone = Microphone.getMicrophone();
			microphone.rate = 44;
			microphone.gain = 60;
			microphone.setSilenceLevel(0, -1);
		}

		sound = new Sound();
		sound.addEventListener(SampleDataEvent.SAMPLE_DATA, playbackSample);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------
	protected static var microphone:Microphone;
	protected var sound:Sound;
	protected var soundChannel:SoundChannel;
	protected var playbackSampleSize:uint = 4096;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------
	//--------------------------------------
	//  playing
	//--------------------------------------
	protected var _playing:Boolean = false;
	[Bindable("playingChanged")]
	public function get playing():Boolean {
		return _playing;
	}
	protected function setPlaying(value:Boolean):void {
		if (_playing != value) {
			_playing = value;
			dispatchEvent(new Event("playingChanged"));
		}
	}

	//--------------------------------------
	//  recording
	//--------------------------------------
	protected var _recording:Boolean = false;
	[Bindable("recordingChanged")]
	public function get recording():Boolean {
		return _recording;
	}
	protected function setRecording(value:Boolean):void {
		if (_recording != value) {
			_recording = value;
			dispatchEvent(new Event("recordingChanged"));
		}
	}

	//--------------------------------------
	//  recordedBytes
	//--------------------------------------
	protected var _recordedBytes:ByteArray;
	[Bindable("recordedBytesChanged")]
	public function get recordedBytes():ByteArray {
		return _recordedBytes;
	}
	public function set recordedBytes(value:ByteArray):void {
		if (_recordedBytes != value) {
			_recordedBytes = value;

			if (recordedBytes) {
				recordedBytes.position = 0;
			}
			_recordedFramesLength = 0;
			_playbackFramesPosition = 0;
			_recordedFramesLength = calcFramesLength();
			dispatchEvent(new Event("playbackPositionChanged"));
			dispatchEvent(new Event("recordedBytesChanged"));
			dispatchEvent(new Event("recordedBytesLengthChanged"));
		}
	}

	//--------------------------------------
	//  recordedFramesLength
	//--------------------------------------
	protected var _recordedFramesLength:Number;
	[Bindable("recordedBytesLengthChanged")]
	public function get recordedFramesLength():Number {
		return _recordedFramesLength;
	}

	//--------------------------------------
	//  playbackFramesPosition
	//--------------------------------------
	protected var _playbackFramesPosition:Number;
	[Bindable("playbackPositionChanged")]
	public function get playbackFramesPosition():Number {
		return _playbackFramesPosition;
	}

	public function set playbackFramesPosition(value:Number):void {
		if (_playbackFramesPosition != value) {
			_playbackFramesPosition = value;
			if (recordedBytes) {
				recordedBytes.position = playbackFramesPosition * 4;
			}
			dispatchEvent(new Event("playbackPositionChanged"));
		}
	}

	//--------------------------------------
	//  playbackTime
	//--------------------------------------
	[Bindable("playbackPositionChanged")]
	public function get playbackTime():String {
		const time:Number = recordedBytes.position / 4 / (microphone.rate * 1000);
		return PlayerUtils.convertToHHMMSS(time);
	}

	//--------------------------------------
	//  timeLength
	//--------------------------------------
	[Bindable("recordedBytesLengthChanged")]
	public function get timeLength():String {
		const time:Number = recordedBytes.length / 4 / (microphone.rate * 1000);
		return PlayerUtils.convertToHHMMSS(time);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------
	//--------------------------------------
	//  public
	//--------------------------------------
	public function record():void {
		removeRecord();
		pause();
		setRecording(true);
		microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, writeSample);
	}

	public function stopRecording():void {
		removeSampleHandler();
		setRecording(false);
	}

	public function play():void {
		if (!recordedBytes) return;

		stopRecording();
		recordedBytes.position = playbackFramesPosition * 4;

		soundChannel = sound.play();
		setPlaying(true);
	}

	public function pause():void {
		if (soundChannel) {
			soundChannel.stop();
			soundChannel = null;
		}
		setPlaying(false)
	}

	/**
	 * Release memory consumed by audio
	 * */
	public function removeRecord():void {
		if (playing) pause();
		recordedBytes = new ByteArray();
		_recordedFramesLength = 0;
		_playbackFramesPosition = 0;

		dispatchEvent(new Event("playbackPositionChanged"));
		dispatchEvent(new Event("recordedBytesLengthChanged"));
	}

	//--------------------------------------
	//  protected
	//--------------------------------------
	protected function playbackSample(event:SampleDataEvent):void {
		if (recordedBytes.bytesAvailable) {
			recordedBytes.position = _playbackFramesPosition * 4;
			for (var i:int = 0; i < playbackSampleSize && recordedBytes.bytesAvailable > 0; i++) {
				const sample:Number = recordedBytes.readFloat();
				_playbackFramesPosition++;

				// stereo output
				event.data.writeFloat(sample);
				event.data.writeFloat(sample);
			}

			dispatchEvent(new Event("playbackPositionChanged"));
		}
		else {
			pause();
			dispatchEvent(new VoiceRecorderEvent(VoiceRecorderEvent.PLAYBACK_FINISHED));
		}
	}

	protected function writeSample(event:SampleDataEvent):void {
		while (event.data.bytesAvailable) {
			const sample:Number = event.data.readFloat();
			recordedBytes.writeFloat(sample);
			_recordedFramesLength++;
		}
		dispatchEvent(new Event("recordedBytesLengthChanged"));
	}

	protected function removeSampleHandler():void {
		microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, writeSample);
	}

	protected function calcFramesLength():Number {
		return recordedBytes ? recordedBytes.length / 4 : 0;
	}
}
}
