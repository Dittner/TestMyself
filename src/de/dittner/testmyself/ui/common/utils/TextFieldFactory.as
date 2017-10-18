package de.dittner.testmyself.ui.common.utils {
import de.dittner.testmyself.ui.common.tile.FadeTextField;

import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFormat;

public class TextFieldFactory {

	public static var useEmbedFonts:Boolean = true;

	public static function create(textFormat:TextFormat):TextField {
		var tf:TextField = new TextField();
		setUpTextField(tf);
		tf.defaultTextFormat = textFormat;
		return tf;
	}

	public static function createMultiline(textFormat:TextFormat):TextField {
		var tf:TextField = new TextField();
		setUpTextField(tf);
		tf.defaultTextFormat = textFormat;
		tf.multiline = true;
		tf.wordWrap = true;
		return tf;
	}

	public static function createFadeTextField(textFormat:TextFormat):FadeTextField {
		var tf:FadeTextField = new FadeTextField();
		setUpTextField(tf);
		tf.defaultTextFormat = textFormat;
		return tf;
	}

	private static function setUpTextField(tf:TextField):void {
		tf.width = 100000;
		tf.height = 100000;
		tf.selectable = false;
		tf.multiline = false;
		tf.wordWrap = false;
		tf.mouseEnabled = false;
		tf.mouseWheelEnabled = false;
		tf.embedFonts = useEmbedFonts;
		tf.antiAliasType = AntiAliasType.ADVANCED;
		tf.gridFitType = GridFitType.PIXEL;
		tf.sharpness = 0;
		tf.thickness = 0;
	}

}
}
