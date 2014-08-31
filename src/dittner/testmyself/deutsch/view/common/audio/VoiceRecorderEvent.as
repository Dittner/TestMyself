package dittner.testmyself.deutsch.view.common.audio {
import flash.events.Event;

public class VoiceRecorderEvent extends Event {
	public static const PLAYBACK_FINISHED:String = "playbackFinished";

	public function VoiceRecorderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
	}
}
}
