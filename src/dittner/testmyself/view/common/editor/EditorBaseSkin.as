package dittner.testmyself.view.common.editor {
import dittner.testmyself.view.utils.AppColors;
import dittner.testmyself.view.utils.FontName;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import spark.skins.mobile.SkinnableContainerSkin;

public class EditorBaseSkin extends SkinnableContainerSkin {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.HELVETICA_NEUE_ULTRALIGHT, 18, 0xccCCcc);
	private static const HEADER_HEIGHT:uint = 40;
	private static const ARROW_SIZE:uint = 10;
	private static const PADDING:uint = 10;
	private static const BORDER_WIDTH:uint = 5;

	public function EditorBaseSkin() {
		super();
	}

	public function get hostScreen():EditorBase {return hostComponent as EditorBase}

	public var titleTf:TextField;
	override protected function createChildren():void {
		titleTf = createTextField();
		titleTf.defaultTextFormat = TITLE_FORMAT;
		addChild(titleTf);

		super.createChildren();
		contentGroup.left = contentGroup.right = contentGroup.bottom = PADDING;
		contentGroup.top = HEADER_HEIGHT + PADDING;
	}

	protected static function createTextField():TextField {
		var textField:TextField = new TextField();
		textField.selectable = false;
		textField.multiline = false;
		textField.wordWrap = false;
		textField.mouseEnabled = false;
		textField.mouseWheelEnabled = false;
		return textField;
	}

	override protected function layoutContents(w:Number, h:Number):void {
		super.layoutContents(w, h);

		updateTitleText();
		titleTf.x = PADDING + BORDER_WIDTH;
		titleTf.y = (HEADER_HEIGHT - titleTf.textHeight + 5) / 2;
		titleTf.width = w - 2 * titleTf.x;
	}

	private function updateTitleText():void {
		if (hostScreen && hostScreen.toolInfo) titleTf.text = hostScreen.toolInfo.description;
	}

	override protected function drawBackground(w:Number, h:Number):void {
		var g:Graphics = graphics;
		g.clear();

		g.beginFill(0, 1);
		g.drawRoundRect(0, ARROW_SIZE, w, h - ARROW_SIZE, 10, 10);
		g.endFill();

		g.beginFill(AppColors.EDITOR_CONTENT_BG, 1);
		g.drawRect(BORDER_WIDTH, HEADER_HEIGHT, w - 2 * BORDER_WIDTH, h - HEADER_HEIGHT - BORDER_WIDTH);
		g.endFill();

		//arrow
		var arrowPosX:Number = hostScreen.arrowPos ? hostScreen.arrowPos.x : w / 2;
		g.lineStyle();
		g.beginFill(0, 1);
		g.moveTo(arrowPosX - ARROW_SIZE / 2, ARROW_SIZE);
		g.lineTo(arrowPosX, 0);
		g.lineTo(arrowPosX + ARROW_SIZE / 2, ARROW_SIZE);
		g.moveTo(arrowPosX - ARROW_SIZE / 2, ARROW_SIZE);
		g.endFill();

	}

}
}
