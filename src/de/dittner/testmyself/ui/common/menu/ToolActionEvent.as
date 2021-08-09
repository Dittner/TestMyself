package de.dittner.testmyself.ui.common.menu {
import flash.events.Event;

public class ToolActionEvent extends Event {

	public static const SELECTED:String = "selected";

	public function ToolActionEvent(type:String, actionID:String, selected:Boolean = false) {
		super(type, true, false);
		_actionID = actionID;
		_selected = selected;
	}

	private var _actionID:String = "";
	public function get actionID():String {return _actionID;}

	private var _selected:Boolean = false;
	public function get selected():Boolean {return _selected;}

	override public function clone():Event {
		return new ToolActionEvent(type, actionID, selected);
	}
}
}