package de.dittner.testmyself.ui.common.audio.event {
import flash.events.Event;

public class VoiceCommentEvent extends Event {

	public static const ADD_COMMENT_CLICK:String = "addCommentClick";
	public static const REMOVE_COMMENT_CLICK:String = "removeCommentClick";

	public function VoiceCommentEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
	}

	override public function clone():Event {
		return new VoiceCommentEvent(type);
	}
}
}
