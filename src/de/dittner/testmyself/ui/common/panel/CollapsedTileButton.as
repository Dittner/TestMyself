package de.dittner.testmyself.ui.common.panel {
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.ui.common.tile.TileID;
import de.dittner.testmyself.utils.Values;

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
		paddingRight = Values.PT12;
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

	override protected function redrawBg():void {
		if (isDown && enabled) {
			if (upBg)
				upBg.alphaTo = selected ? 0 : 1;

			if (downBg)
				downBg.alphaTo = 1;

			if (disabledBg)
				disabledBg.alphaTo = 0;
		}
		else if (isHover && enabled) {
			if (upBg)
				upBg.alphaTo = selected ? 0 : 1;

			if (downBg)
				downBg.alphaTo = selected ? 1 : 0;

			if (disabledBg)
				disabledBg.alphaTo = 0;
		}
		else {
			if (upBg)
				upBg.alphaTo = enabled ? selected ? 0 : upBgAlpha : disabledBgAlpha;

			if (downBg)
				downBg.alphaTo = selected ? enabled ? 1 : disabledBgAlpha : 0;

			if (disabledBg)
				disabledBg.alphaTo = enabled ? 0 : 1;
		}
	}

}
}
