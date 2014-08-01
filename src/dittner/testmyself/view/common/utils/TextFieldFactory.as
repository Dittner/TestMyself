package dittner.testmyself.view.common.utils {
import flash.text.TextField;
import flash.text.TextFormat;

public class TextFieldFactory {
	public function TextFieldFactory() {
	}

	public static var useEmbedFonts:Boolean = false;

	public static function create(textFormat:TextFormat, multiline:Boolean = false):TextField {
		var textField:TextField = new TextField();
		textField.selectable = false;
		textField.multiline = multiline;
		textField.wordWrap = multiline;
		textField.embedFonts = true;
		textField.mouseEnabled = false;
		textField.mouseWheelEnabled = false;
		textField.embedFonts = useEmbedFonts;
		textField.defaultTextFormat = textFormat;
		return textField;
	}

}
}
