package de.dittner.testmyself.ui.common.button {
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.ui.common.tile.TileID;

public class RedButton extends FadeTileButton{
	public function RedButton() {
		super();
		use9Scale = true;
		upTileID = TileID.BTN_RED;
		textColor = 0xffFFff;
	}
}
}
