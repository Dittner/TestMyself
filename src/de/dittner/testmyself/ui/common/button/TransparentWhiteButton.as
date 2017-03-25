package de.dittner.testmyself.ui.common.button {
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.ui.common.tile.TileID;

public class TransparentWhiteButton extends FadeTileButton{
	public function TransparentWhiteButton() {
		super();
		use9Scale = true;
		upTileID = TileID.BTN_TRANSPARENT_WHITE;
		textColor = 0xffFFff;
	}
}
}
