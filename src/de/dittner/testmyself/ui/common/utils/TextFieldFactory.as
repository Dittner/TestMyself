package de.dittner.testmyself.ui.common.utils {
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFormat;

public class TextFieldFactory {

	public static var useEmbedFonts:Boolean = true;

	public static function create(textFormat:TextFormat, multiline:Boolean = false):TextField {
		var textField:TextField = new TextField();
		textField.width = 100000;
		textField.height = 100000;
		textField.selectable = false;
		textField.multiline = multiline;
		textField.wordWrap = multiline;
		textField.mouseEnabled = false;
		textField.mouseWheelEnabled = false;
		textField.embedFonts = useEmbedFonts;
		textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.gridFitType = GridFitType.PIXEL;
		textField.sharpness = 0;
		textField.thickness = 50;
		textField.defaultTextFormat = textFormat;
		return textField;
	}

}
}
