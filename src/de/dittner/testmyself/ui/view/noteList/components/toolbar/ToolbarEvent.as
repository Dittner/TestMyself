package de.dittner.testmyself.ui.view.noteList.components.toolbar {
import flash.events.Event;

public class ToolbarEvent extends Event {

	public static const SELECTED:String = "selected";

	public function ToolbarEvent(type:String, toolAction:String) {
		super(type, true, false);
		_toolAction = toolAction;
	}

	private var _toolAction:String = "";
	public function get toolAction():String { return _toolAction; }

	override public function clone():Event {
		return new ToolbarEvent(type, toolAction);
	}
}
}