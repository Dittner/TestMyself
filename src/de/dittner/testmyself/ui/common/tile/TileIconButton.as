package de.dittner.testmyself.ui.common.tile {
import de.dittner.testmyself.utils.Values;

import flash.events.Event;

[Event(name="click", type="flash.events.MouseEvent")]

public class TileIconButton extends TitleTileButton {
	public function TileIconButton() {
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
		bg.x = -shadowSize + paddingLeft;
		titleTf.x = bg.x + bg.width - shadowSize + gap;
		titleTf.y = (h - titleTf.textHeight >> 1) - Values.PT2;
	}

}
}
