package de.dittner.testmyself.ui.view.noteList.components.form.articleList {
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.ui.common.tile.TileID;
import de.dittner.testmyself.ui.common.tile.TileShape;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.utils.Values;

import flash.text.TextField;
import flash.text.TextFormat;

import spark.skins.mobile.ListSkin;

public class ListBoxSkin extends ListSkin {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT15, AppColors.TEXT_CONTROL_TITLE);
	private static const TITLE_HEIGHT:uint = Values.PT20;
	public function ListBoxSkin() {
		super();
	}

	public var dropDownBtn:FadeTileButton;
	private var titleDisplay:TextField;
	private var bg:TileShape;

	override protected function createChildren():void {
		if (!bg) {
			bg = new TileShape(TileID.WHITE_BG_ICON);
			addChild(bg);
		}

		super.createChildren();

		dropDownBtn = new FadeTileButton();
		dropDownBtn.upTileID = TileID.BTN_TITLED_DROPDOWN;
		dropDownBtn.use9Scale = true;
		dropDownBtn.isToggle = true;
		dropDownBtn.selected = true;
		dropDownBtn.deselectOnlyProgrammatically = true;
		dropDownBtn.paddingLeft = Values.PT2;
		dropDownBtn.paddingRight = Values.PT16;
		dropDownBtn.textColor = 0;
		dropDownBtn.fontSize = Values.PT18;
		addChild(dropDownBtn);
		addChild(titleDisplay = TextFieldFactory.create(TITLE_FORMAT));
	}

	override protected function measure():void {
		super.measure();
		measuredHeight = Math.min(Values.PT500, dataGroup.getExplicitOrMeasuredHeight() + TITLE_HEIGHT + dropDownBtn.height);
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		titleDisplay.text = resourceManager.getString('app', 'Article');
		titleDisplay.x = -Values.PT2;
		titleDisplay.y = 0;

		dropDownBtn.width = w;
		dropDownBtn.y = TITLE_HEIGHT;

		scroller.x = 1;
		scroller.y = dropDownBtn.height + dropDownBtn.y + 1;
		scroller.width = w - 2;
		scroller.height = h - scroller.y - 1;

		if (scroller.visible) {
			bg.visible = true;
			bg.x = 0;
			bg.y = scroller.y;
			bg.width = w;
			bg.height = Math.min(scroller.height, dataGroup.getExplicitOrMeasuredHeight());
		}
		else {
			bg.visible = false;
		}
	}
}
}