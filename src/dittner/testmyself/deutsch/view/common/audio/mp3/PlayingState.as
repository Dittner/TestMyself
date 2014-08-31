package dittner.testmyself.deutsch.view.common.audio.mp3 {
import flash.events.Event;
import flash.events.TimerEvent;
import flash.media.SoundChannel;
import flash.media.SoundMixer;
import flash.utils.Timer;

public class PlayingState implements IPlayerState {
	public function PlayingState(context:IPlayerContext) {
		this.context = context;
		playingTimer.addEventListener(TimerEvent.TIMER, playingProgress);
	}

	private var context:IPlayerContext;
	private var isPlaying:Boolean = false;
	private var soundChannel:SoundChannel;
	private var playingTimer:Timer = new Timer(500);

	public function play():void {
		if (isPlaying) {
			stopPlaying();
		}
		isPlaying = true;

		var posInSec:int = context.playbackTime;

		soundChannel = context.sound.play(posInSec * 1000);
		if (!soundChannel) soundChannel = context.sound.play(0);

		soundChannel.addEventListener(Event.SOUND_COMPLETE, playingComplete);
		playingTimer.reset();
		playingTimer.start();
	}

	public function updatePlayingPosition():void {
		play();
	}

	public function pause():void {
		if (isPlaying) {
			isPlaying = false;
			stopPlaying();
			context.curState = context.getPausedState();
		}
	}

	private function stopPlaying():void {
		soundChannel.removeEventListener(Event.SOUND_COMPLETE, playingComplete);
		playingTimer.stop();
		SoundMixer.stopAll();
	}

	public function stop():void {
		if (isPlaying) {
			isPlaying = false;
			stopPlaying();
			context.updatePlayback(0);
			context.curState = context.getStoppedState();
		}
	}

	private function playingProgress(event:TimerEvent):void {
		context.updatePlayback(Math.ceil(soundChannel.position / 1000));
	}

	private function playingComplete(event:Event):void {
		stop();
	}
}
}
