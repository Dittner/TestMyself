package de.dittner.testmyself.ui.common.panel {
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.ui.common.tile.TileID;
import de.dittner.testmyself.utils.Values;

import flash.events.MouseEvent;

[Event(name="change", type="flash.events.Event")]

public class CollapsedTileButton extends FadeTileButton {

	public function CollapsedTileButton() {
		super();
		isToggle = true;
		upTileID = TileID.BTN_COLLAPSED_UP;
		downTileID = TileID.BTN_COLLAPSED_DOWN;
		iconTileID = TileID.CLOSED_LIST_ICON;
		fontSize = Values.PT18;
		isBold = true;
		textColor = 0x858586;
		use9Scale = true;
		paddingRight = Values.PT17;
		upBgAlpha = 1;
	}

	override public function set selected(value:Boolean):void {
		if (selected != value) {
			super.selected = value;
			iconTileID = selected ? TileID.OPENED_LIST_ICON : TileID.CLOSED_LIST_ICON;
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function createChildren():void {
		super.createChildren();
	}

	override protected function measure():void {
		super.measure();
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		if (iconBg) {
			iconBg.x = w - paddingRight - iconBg.width;
		}
	}

	override protected function mouseOverHandler(event:MouseEvent):void {
		if (upBg)
			upBg.alphaTo = enabled ? selected ? 0 : 1 : disabledBgAlpha;

		if (downBg)
			downBg.alphaTo = selected ? enabled ? 1 : disabledBgAlpha : 0;

		if (disabledBg)
			disabledBg.alphaTo = enabled ? 0 : 1;
	}

	override protected function mouseDownHandler(event:MouseEvent):void {
		isDown = true;

		if (upBg)
			upBg.alphaTo = enabled ? selected ? 0 : 1 : disabledBgAlpha;

		if (downBg)
			downBg.alphaTo = enabled ? 1 : disabledBgAlpha;

		if (disabledBg)
			disabledBg.alphaTo = enabled ? 0 : 1;
	}

	override protected function mouseOutHandler(event:MouseEvent):void {
		isDown = false;

		if (upBg)
			upBg.alphaTo = enabled ? selected ? 0 : upBgAlpha : disabledBgAlpha;

		if (downBg)
			downBg.alphaTo = selected ? enabled ? 1 : disabledBgAlpha : 0;

		if (disabledBg)
			disabledBg.alphaTo = enabled ? 0 : 1;
	}

	override protected function redrawBg():void {
		if (upBg)
			upBg.alphaTo = enabled ? selected ? 0 : upBgAlpha : disabledBgAlpha;

		if (downBg)
			downBg.alphaTo = selected ? enabled ? 1 : disabledBgAlpha : 0;

		if (disabledBg)
			disabledBg.alphaTo = enabled ? 0 : 1;
	}

}
}
