package de.dittner.testmyself.ui.common.tileClasses {
import flash.events.Event;
import flash.events.MouseEvent;

[Event(name="change", type="flash.events.Event")]

public class TileToggleButton extends TileButton {
	public function TileToggleButton() {
		super();
	}

	//--------------------------------------
	//  selectedTileID
	//--------------------------------------
	protected var _selectedTileID:String = "";
	public function get selectedTileID():String {return _selectedTileID;}
	public function set selectedTileID(value:String):void {
		if (_selectedTileID != value) {
			_selectedTileID = value;
			updateActualTileID();
		}
	}

	//--------------------------------------
	//  selected
	//--------------------------------------
	private var denyInteractiveSelection:Boolean = false;
	private var _selected:Boolean = false;
	[Bindable(event='selectedChange')]
	public function get selected():Boolean {return _selected;}
	public function set selected(value:Boolean):void {
		if (_selected != value) {
			_selected = value;
			if (isDown) denyInteractiveSelection = true;
			updateActualTileID();
			dispatchEvent(new Event("selectedChange"))
		}
	}

	//--------------------------------------
	//  deselectOnlyProgrammatically
	//--------------------------------------
	private var _deselectOnlyProgrammatically:Boolean = false;
	[Bindable("deselectOnlyProgrammaticallyChanged")]
	public function get deselectOnlyProgrammatically():Boolean {return _deselectOnlyProgrammatically;}
	public function set deselectOnlyProgrammatically(value:Boolean):void {
		if (_deselectOnlyProgrammatically != value) {
			_deselectOnlyProgrammatically = value;
			dispatchEvent(new Event("deselectOnlyProgrammaticallyChanged"));
		}
	}

	override protected function mouseUpHandler(event:MouseEvent):void {
		if (isDown) {
			isDown = false;
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			if (denyInteractiveSelection) {
				denyInteractiveSelection = false;
			}
			else {
				var oldSelected:Boolean = selected;
				selected = selected ? deselectOnlyProgrammatically : true;
				if (selected != oldSelected)
					dispatchEvent(new Event(Event.CHANGE));
			}
			updateActualTileID();
		}
	}

	override protected function updateActualTileID():void {
		if (upTileID && !isDown && !selected) actualTileID = upTileID;
		else if (selectedTileID && selected && !isDown) actualTileID = selectedTileID;
		else if (downTileID && (isDown || (selected && !selectedTileID))) actualTileID = downTileID;
	}
}
}
