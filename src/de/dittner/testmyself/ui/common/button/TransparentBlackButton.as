package de.dittner.testmyself.ui.common.button {
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.ui.common.tile.TileID;

public class TransparentBlackButton extends FadeTileButton{
	public function TransparentBlackButton() {
		super();
		use9Scale = true;
		upTileID = TileID.BTN_TRANSPARENT_BLACK;
		textColor = 0;
	}
}
}
