package de.dittner.testmyself.ui.common.utils {
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFormat;

public class TextFieldFactory {

	public static var useEmbedFonts:Boolean = true;

	public static function create(textFormat:TextFormat, thickness:Number = 10):TextField {
		var textField:TextField = new TextField();
		textField.width = 100000;
		textField.height = 100000;
		textField.selectable = false;
		textField.multiline = false;
		textField.wordWrap = false;
		textField.mouseEnabled = false;
		textField.mouseWheelEnabled = false;
		textField.embedFonts = useEmbedFonts;
		textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.gridFitType = GridFitType.PIXEL;
		textField.sharpness = 0;
		textField.thickness = thickness;
		textField.defaultTextFormat = textFormat;
		return textField;
	}

	public static function createMultiline(textFormat:TextFormat, thickness:Number = 20):TextField {
		var textField:TextField = create(textFormat, thickness);
		textField.multiline = true;
		textField.wordWrap = true;
		return textField;
	}

}
}
