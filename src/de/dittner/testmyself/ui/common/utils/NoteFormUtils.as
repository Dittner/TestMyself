package de.dittner.testmyself.ui.common.utils {
public class NoteFormUtils {
	public static const LETTERS:RegExp = /[a-zA-ZÄäÖöÜüß-]+/;
	public static const LETTERS_AND_SYMBOLS:RegExp = /[a-zA-ZÄäÖöÜüß *\/-]+/;

	public static function capitalizeText(text:String):String {
		return addDot(capitalize(changeSymbols(removeSpaces(text))));
	}

	public static function removeSpaces(str:String):String {
		if (str) {
			str = str.replace(/(  )/gi, " ");
			str = str.replace(/(  )/gi, " ");
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

	public static function formatText(txt:String):String {
		var res:String = "";
		if (txt) {
			txt = removeSpaces(txt);
			txt = txt.replace(/(\[)/gi, "");
			txt = txt.replace(/(\])/gi, "");
			txt = txt.replace(/(\()/gi, "");
			txt = txt.replace(/(0\))/gi, "0]");
			txt = txt.replace(/(1\))/gi, "1]");
			txt = txt.replace(/(2\))/gi, "2]");
			txt = txt.replace(/(3\))/gi, "3]");
			txt = txt.replace(/(4\))/gi, "4]");
			txt = txt.replace(/(5\))/gi, "5]");
			txt = txt.replace(/(6\))/gi, "6]");
			txt = txt.replace(/(7\))/gi, "7]");
			txt = txt.replace(/(8\))/gi, "8]");
			txt = txt.replace(/(9\))/gi, "9]");
			txt = txt.replace(/(\))/gi, "");
			txt = txt.replace(/(\])/gi, ")");

			txt = txt.replace(/(\r)/gi, "\n");
			txt = txt.replace(/(\t)/gi, "\n");
			txt = txt.replace(/(\n\n)/gi, "\n");
			txt = txt.replace(/(\n\n)/gi, "\n");

			txt = txt.replace(/(что-л\.)/gi, "ч-л.");
			txt = txt.replace(/(что-либо)/gi, "ч-л.");
			txt = txt.replace(/(кто-либо)/gi, "к-л.");
			txt = txt.replace(/(кто-л\.)/gi, "к-л.");

			txt = txt.replace(/(чего-л\.)/gi, "ч-л.");
			txt = txt.replace(/(чего-либо)/gi, "ч-л.");
			txt = txt.replace(/(кого-л\.)/gi, "к-л.");
			txt = txt.replace(/(кого-либо)/gi, "к-л.");

			txt = txt.replace(/(чему-л\.)/gi, "ч-л.");
			txt = txt.replace(/(чему-либо)/gi, "ч-л.");
			txt = txt.replace(/(кому-л\.)/gi, "к-л.");
			txt = txt.replace(/(кому-либо)/gi, "к-л.");

			txt = txt.replace(/(чем-л\.)/gi, "ч-л.");
			txt = txt.replace(/(чем-либо)/gi, "ч-л.");
			txt = txt.replace(/(кем-л\.)/gi, "к-л.");
			txt = txt.replace(/(кем-либо)/gi, "к-л.");

			txt = txt.replace(/(чём-л\.)/gi, "ч-л.");
			txt = txt.replace(/(чём-либо)/gi, "ч-л.");
			txt = txt.replace(/(ком-л\.)/gi, "к-л.");
			txt = txt.replace(/(ком-либо)/gi, "к-л.");

			txt = txt.replace(/(  )/gi, " ");
			txt = txt.replace(/(  )/gi, " ");
			txt = txt.replace(/(;;)/gi, ";");
			txt = txt.replace(/(;)/gi, ",");
			txt = txt.replace(/(,,)/gi, ",");
			txt = txt.replace(/(,\n)/gi, "\n");
			if (txt && (txt.charAt(txt.length - 1) == "\n" || txt.charAt(txt.length - 1) == "." || txt.charAt(txt.length - 1) == "," || txt.charAt(txt.length - 1) == ";"))
				txt = txt.substr(0, txt.length - 1);
			txt = txt.replace(/(,;|;;|\n)/gi, ";");
			txt = txt.replace(/(;)/gi, ";\n");
			txt = txt.replace(/(, ;)/gi, ";");
			res = removeSpaces(txt);

		}
		return res;
	}


}
}
