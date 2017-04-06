package de.dittner.testmyself.ui.common.tile {
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.utils.Values;

import flash.events.Event;

import spark.components.Group;

public class TileRadioButton extends FadeTileButton {
	public function TileRadioButton() {
		super();
		isToggle = true;
		deselectOnlyProgrammatically = true;
		upTileID = TileID.BTN_RADIO_UP;
		downTileID = TileID.BTN_RADIO_DOWN;
		paddingLeft = Values.PT30;
		paddingRight = 0;
		fontSize = Values.PT20;
		textColor = AppColors.TEXT_BLACK;
		isItalic = true;
	}

	//--------------------------------------
	//  radioGroup
	//--------------------------------------
	private var _radioGroup:Group;
	[Bindable("radioGroupChanged")]
	public function get radioGroup():Group {return _radioGroup;}
	public function set radioGroup(value:Group):void {
		if (_radioGroup != value) {
			_radioGroup = value;
			dispatchEvent(new Event("radioGroupChanged"));
		}
	}

	override public function set selected(value:Boolean):void {
		if (super.selected != value) {
			super.selected = value;
			if (super.selected && radioGroup) {
				for (var i:int = 0; i < radioGroup.numElements; i++) {
					var btn:TileRadioButton = radioGroup.getElementAt(i) as TileRadioButton;
					if (btn && btn != this && btn.radioGroup == radioGroup)
						btn.selected = false;
				}
			}
		}
	}
}
}
