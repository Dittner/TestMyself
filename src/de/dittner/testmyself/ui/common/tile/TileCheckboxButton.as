package de.dittner.testmyself.ui.common.tile {
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.utils.Values;

public class TileCheckboxButton extends FadeTileButton {
	public function TileCheckboxButton() {
		super();
		isToggle = true;
		upTileID = TileID.BTN_CHECKBOX_UP;
		downTileID = TileID.BTN_CHECKBOX_DOWN;
		paddingLeft = Values.PT30;
		paddingRight = 0;
		fontSize = Values.PT20;
		textColor = AppColors.BLACK;
		isItalic = true;
	}
}
}
