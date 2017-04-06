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
		fontSize = Values.PT20;
		use9Scale = true;
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
	}

}
}
