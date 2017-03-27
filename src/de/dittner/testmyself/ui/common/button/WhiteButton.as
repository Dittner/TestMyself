package de.dittner.testmyself.ui.common.button {
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.ui.common.tile.TileID;

public class WhiteButton extends FadeTileButton{
	public function WhiteButton() {
		super();
		use9Scale = true;
		upTileID = TileID.BTN_WHITE_UP;
		downTileID = TileID.BTN_WHITE_DOWN;
		upBgAlpha = 1;
		textColor = 0;
	}
}
}
