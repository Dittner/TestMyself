package de.dittner.testmyself.ui.common.button {
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.ui.common.tile.TileID;

public class BlackButton extends FadeTileButton{
	public function BlackButton() {
		super();
		use9Scale = true;
		upTileID = TileID.BTN_BLACK;
		textColor = 0xffFFff;
	}
}
}
