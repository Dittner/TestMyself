package de.dittner.testmyself.ui.common.list {
import de.dittner.testmyself.ui.common.tile.TileID;
import de.dittner.testmyself.ui.common.tile.TileShape;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.utils.Values;

import flash.text.TextField;
import flash.text.TextFormat;

import spark.skins.mobile.ListSkin;

public class ListFormSkin extends ListSkin {

	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT15, AppColors.TEXT_CONTROL_TITLE);
	private static const TITLE_HEIGHT:uint = Values.PT20;

	public function ListFormSkin() {
		super();
	}

	private var bg:TileShape;
	private var titleDisplay:TextField;
	private function get hostInput():ListForm {return hostComponent as ListForm;}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	override protected function createChildren():void {
		if (!bg) {
			bg = new TileShape(TileID.WHITE_BG_ICON);
			addChild(bg);
		}

		super.createChildren();

		if (!titleDisplay) {
			titleDisplay = TextFieldFactory.create(TITLE_FORMAT);
			addChild(titleDisplay);
		}
	}

	override protected function measure():void {
		measuredWidth = scroller.getPreferredBoundsWidth();
		measuredHeight = Math.max(scroller.getPreferredBoundsHeight(), dataGroup.getExplicitOrMeasuredHeight());
		measuredHeight += hostInput.showTitle ? TITLE_HEIGHT : 0;
	}

	override protected function drawBackground(w:Number, h:Number):void {}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		if (w > 0 && h > 0) {
			var bgVerOffset:Number = hostInput.showTitle ? TITLE_HEIGHT : 0;
			bg.x = 0;
			bg.y = bgVerOffset;
			bg.width = w;
			bg.height = h - bgVerOffset;

			titleDisplay.visible = hostInput.showTitle;
			titleDisplay.text = hostInput.title;
			titleDisplay.x = -2;
			titleDisplay.y = 0;
			titleDisplay.width = w;
			titleDisplay.height = TITLE_HEIGHT;

			scroller.x = 1;
			scroller.y = hostInput.showTitle ? TITLE_HEIGHT + 1 : 1;
			dataGroup.width = w - 2;
			scroller.width = w - 2 + Values.PT10;//otherwise its blocking right side of content
			scroller.height = h - scroller.y - 1;
		}
	}

}
}