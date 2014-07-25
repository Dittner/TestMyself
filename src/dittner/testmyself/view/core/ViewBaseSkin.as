package dittner.testmyself.view.core {
import dittner.testmyself.view.utils.FontName;

import flash.text.TextField;
import flash.text.TextFormat;

import spark.skins.mobile.SkinnableContainerSkin;

public class ViewBaseSkin extends SkinnableContainerSkin {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.HELVETICA_NEUE_LIGHT, 18, 0xffFFff);
	private static const TITLE_PAD:uint = 20;

	public function ViewBaseSkin() {
		super();
	}

	public var titleTf:TextField;
	override protected function createChildren():void {
		titleTf = createTextField();
		titleTf.defaultTextFormat = TITLE_FORMAT;
		addChild(titleTf);
		super.createChildren();
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

	override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void {
		super.layoutContents(unscaledWidth, unscaledHeight);
		updateTitleText();
		titleTf.x = TITLE_PAD;
		titleTf.y = TITLE_PAD;
		titleTf.width = unscaledWidth - 2 * TITLE_PAD;
	}

	override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void {}

	private function updateTitleText():void {
		if (hostComponent is ViewBase && titleTf)
			titleTf.text = (hostComponent as ViewBase).info.title;
	}
}
}
