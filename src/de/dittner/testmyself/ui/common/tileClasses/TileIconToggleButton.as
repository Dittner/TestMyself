package de.dittner.testmyself.ui.common.tileClasses {
import de.dittner.testmyself.utils.Values;

import flash.events.Event;

[Event(name="click", type="flash.events.MouseEvent")]

public class TileIconToggleButton extends TitleTileToggleButton {
	public function TileIconToggleButton() {
		super();
		use9Scale = false;
		paddingLeft = 0;
		paddingRight = 0;
	}

	//--------------------------------------
	//  gap
	//--------------------------------------
	private var _gap:Number = Values.PT10;
	[Bindable("gapChanged")]
	public function get gap():Number {return _gap;}
	public function set gap(value:Number):void {
		if (_gap != value) {
			_gap = value;
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("gapChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function measure():void {
		super.measure();
		measuredWidth = titleTf.textWidth + paddingLeft + paddingRight + gap + bg.width - 2 * shadowSize;
		measuredHeight = Math.max(titleTf.textHeight, bg.height - 2 * shadowSize);
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		titleTf.x = paddingLeft;
		titleTf.y = (h - titleTf.textHeight >> 1) - Values.PT2;
		bg.x = w - bg.width - paddingRight - shadowSize;
		bg.y = h - bg.height >> 1;
	}

	override protected function updateActualTileID():void {
		if (upTileID && !isDown && !selected) actualTileID = upTileID;
		else if (selectedTileID && selected && !isDown) actualTileID = selectedTileID;
		else if (downTileID && (isDown || (selected && !selectedTileID))) actualTileID = downTileID;
		else actualTileID = ""
	}

}
}
