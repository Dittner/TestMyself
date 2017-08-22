package de.dittner.testmyself.ui.common.utils {
public class NoteFormUtils {
	public static const LETTERS:RegExp = /[a-zA-ZÄäÖöÜüß-]+/;
	public static const LETTERS_AND_SYMBOLS:RegExp = /[a-zA-ZÄäÖöÜüß *\/-]+/;

	public static function capitalizeAndFormatText(text:String):String {
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

	public static function changeSymbols(txt:String):String {
		if (txt) {
			txt = txt.replace(/(\[)/gi, "(");
			txt = txt.replace(/(\])/gi, ")");
			txt = txt.replace(/(„)/gi, '"');
			txt = txt.replace(/(“)/gi, '"');
			txt = txt.replace(/(”)/gi, '"');
			txt = txt.replace(/(«)/gi, '"');
			txt = txt.replace(/(»)/gi, '"');
			txt = txt.replace(/(")/gi, '"');
			txt = txt.replace(/(–)/gi, "-");
			txt = txt.replace(/( - )/gi, " – ");
		}
		return txt;
	}

	public static function addDot(str:String):String {
		if (str) {
			var endChar:String = str.charAt(str.length - 1);
			if (endChar != "." && endChar != "!" && endChar != "?" && endChar != '"')
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
			txt = txt.replace(/(„)/gi, '"');
			txt = txt.replace(/(“)/gi, '"');
			txt = txt.replace(/(«)/gi, '"');
			txt = txt.replace(/(»)/gi, '"');

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
			txt = txt.replace(/(разг )/gi, "umg. ");
			txt = txt.replace(/(разг\.)/gi, "umg.");
			txt = txt.replace(/(перен )/gi, "перен. ");
			txt = txt.replace(/(уст )/gi, "уст. ");
			txt = txt.replace(/(физ )/gi, "физ. ");
			txt = txt.replace(/(астр )/gi, "астр. ");
			txt = txt.replace(/(хим )/gi, "хим. ");
			txt = txt.replace(/(диал )/gi, "диал. ");
			txt = txt.replace(/(ист )/gi, "ист. ");
			txt = txt.replace(/(ав )/gi, "ав. ");
			txt = txt.replace(/(эл )/gi, "эл. ");
			txt = txt.replace(/(лингв )/gi, "лингв. ");
			txt = txt.replace(/(полит )/gi, "полит. ");
			txt = txt.replace(/(биол )/gi, "биол. ");
			txt = txt.replace(/(зоол )/gi, "зоол. ");
			txt = txt.replace(/(анат )/gi, "анат. ");
			txt = txt.replace(/(мед )/gi, "мед. ");
			txt = txt.replace(/(информ )/gi, "инф. ");
			txt = txt.replace(/(инф )/gi, "инф. ");
			txt = txt.replace(/(вчт )/gi, "инф. ");
			txt = txt.replace(/(комп )/gi, "инф. ");
			txt = txt.replace(/(фам )/gi, "фам. ");
			txt = txt.replace(/(геол )/gi, "геол. ");
			txt = txt.replace(/(социол )/gi, "социол. ");
			txt = txt.replace(/(тех )/gi, "тех. ");
			txt = txt.replace(/(рел )/gi, "рел. ");
			txt = txt.replace(/(мат )/gi, "мат. ");
			txt = txt.replace(/(матем )/gi, "мат. ");
			txt = txt.replace(/(стр )/gi, "стр. ");
			txt = txt.replace(/(эк )/gi, "эк. ");
			txt = txt.replace(/(юр )/gi, "юр. ");
			txt = txt.replace(/(кул )/gi, "кул. ");
			txt = txt.replace(/(стр )/gi, "стр. ");
			txt = txt.replace(/(театр )/gi, "театр. ");
			txt = txt.replace(/(груб )/gi, "груб. ");
			txt = txt.replace(/(высок )/gi, "высок. ");
			txt = txt.replace(/(презр )/gi, "презр. ");
			txt = txt.replace(/(канц )/gi, "канц. ");
			txt = txt.replace(/(геогр )/gi, "геогр. ");
			txt = txt.replace(/(воен )/gi, "воен. ");
			txt = txt.replace(/(бот )/gi, "бот. ");
			txt = txt.replace(/(напр )/gi, "напр. ");
			txt = txt.replace(/(психол )/gi, "психол. ");
			txt = txt.replace(/(муз )/gi, "муз. ");
			txt = txt.replace(/(шутл )/gi, "шутл. ");
			txt = txt.replace(/(неодобр )/gi, "неодобр. ");
			txt = txt.replace(/(спорт )/gi, "спорт. ");
			txt = txt.replace(/(англ )/gi, "англ. ");
			txt = txt.replace(/(фр )/gi, "фр. ");
			txt = txt.replace(/(мор )/gi, "мор. ");
			txt = txt.replace(/(библ )/gi, "библ. ");
			txt = txt.replace(/(полигр )/gi, "полигр. ");
			txt = txt.replace(/(охот )/gi, "охот. ");
			txt = txt.replace(/(фин )/gi, "фин. ");
			txt = txt.replace(/(ком )/gi, "ком. ");

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
			txt = setNumberingToText(txt);
			res = removeSpaces(txt);
		}
		return res;
	}

	public static function setNumberingToText(txt:String):String {
		var res:String = "";
		var rows:Array = txt.split("\n");
		if (rows && rows.length > 1) {
			for (var i:int = 0; i < rows.length; i++) {
				var row:String = rows[i];
				var number:String = (i + 1) + ")";
				if (row.indexOf(number) == 0)
					res += row;
				else
					res += number + " " + row;
				if (i < rows.length - 1)
					res += "\n";
			}
		}
		else {
			res = txt;
		}
		return res;
	}

}
}
