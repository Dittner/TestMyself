package de.dittner.testmyself.ui.view.dictionary.common {
public class NoteUtils {
	public static const LETTERS:RegExp = /[a-zA-ZÄäÖöÜüß-]+/;
	public static const LETTERS_AND_SYMBOLS:RegExp = /[a-zA-ZÄäÖöÜüß *\/-]+/;

	public static function correctText(text:String):String {
		return addDot(capitalize(changeSymbols(removeSpaces(text))));
	}

	public static function removeSpaces(str:String):String {
		if (str) {
			while (str.length > 0 && (str.charAt(0) == " " || str.charAt(0) == "\n" || str.charAt(0) == "\r")) {
				str = str.substring(1, str.length);
			}
			while (str.length > 0 && (str.charAt(str.length - 1) == " " || str.charAt(str.length - 1) == "\n" || str.charAt(str.length - 1) == "\r")) {
				str = str.substring(0, str.length - 1);
			}
		}
		return str;
	}

	public static function capitalize(str:String):String {
		if (str) {
			var temp:String = str.charAt(0);
			temp = temp.toUpperCase();
			temp += str.substring(1, str.length);
			str = temp;
		}
		return str;
	}

	public static function changeSymbols(str:String):String {
		if (str) {
			str = str.replace(/(\[)/gi, "(");
			str = str.replace(/(\])/gi, ")");
			str = str.replace(/( - )/gi, " – ");
		}
		return str;
	}

	public static function addDot(str:String):String {
		if (str) {
			var endChar:String = str.charAt(str.length - 1);
			if (endChar != "." && endChar != "!" && endChar != "?")
				str += ".";
		}
		return str;
	}

}
}
