package dittner.testmyself.deutsch.view.common.audio.event {
import flash.events.Event;

public class VoiceCommentEvent extends Event {

	public static const ADD_COMMENT_CLICK:String = "addCommentClick";
	public static const REMOVE_COMMENT_CLICK:String = "removeCommentClick";

	public function VoiceCommentEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
	}
}
}
