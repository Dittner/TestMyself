package de.dittner.testmyself.ui.common.button {
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.ui.common.tile.TileID;

public class YellowButton extends FadeTileButton{
	public function YellowButton() {
		super();
		use9Scale = true;
		upTileID = TileID.BTN_YELLOW;
		textColor = 0;
	}
}
}
