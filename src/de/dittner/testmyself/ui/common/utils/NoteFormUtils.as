package de.dittner.testmyself.ui.common.utils {
public class NoteFormUtils {
	public static const LETTERS:RegExp = /[a-zA-ZÄäÖöÜüß-]+/;
	public static const LETTERS_AND_SYMBOLS:RegExp = /[a-zA-ZÄäÖöÜüß *\/-]+/;

	public static function capitalizeAndFormatText(text:String):String {
		return addDot(capitalize(changeSymbols(removeSpaces(text))));
	}

	public static function removeSpaces(str:String):String {
		if (str) {
			str = str.replace(/( {2,})/gi, " ");
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
			txt = txt.replace(/(ё)/gi, "е");
			txt = txt.replace(/(Ё)/gi, "Е");
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
			if (endChar != "." && endChar != "!" && endChar != "?")
				str += ".";
		}
		return str;
	}

	public static function formatText(txt:String):String {
		var res:String = "";
		if (txt) {
			txt = removeSpaces(txt);
			txt = "#" + txt;
			txt = txt.replace(/_([А-Яа-яёЁ].)/gi, "$1");
			txt = txt.replace(/(ё)/gi, "е");
			txt = txt.replace(/(Ё)/gi, "Е");
			txt = txt.replace(/(\[)/gi, "");
			txt = txt.replace(/(\])/gi, "");
			txt = txt.replace(/(\()/gi, "");
			txt = txt.replace(/(\d+\) ?)/gi, "");
			txt = txt.replace(/(\))/gi, "");
			txt = txt.replace(/(„)/gi, '"');
			txt = txt.replace(/(“)/gi, '"');
			txt = txt.replace(/(«)/gi, '"');
			txt = txt.replace(/(»)/gi, '"');
			txt = txt.replace(/( - )/gi, " – ");

			txt = txt.replace(/(\r)/gi, "\n");
			txt = txt.replace(/(\t)/gi, "\n");
			txt = txt.replace(/(\n\n)/gi, "\n");
			txt = txt.replace(/(\n\n)/gi, "\n");

			txt = txt.replace(/(\W)(что-л\.)/gi, "$1ч-л.");
			txt = txt.replace(/(\W)(что-либо)/gi, "$1ч-л.");
			txt = txt.replace(/(\W)(кто-либо)/gi, "$1к-л.");
			txt = txt.replace(/(\W)(кто-л\.)/gi, "$1к-л.");

			txt = txt.replace(/(\W)(чего-л\.)/gi, "$1ч-л.");
			txt = txt.replace(/(\W)(чего-либо)/gi, "$1ч-л.");
			txt = txt.replace(/(\W)(кого-л\.)/gi, "$1к-л.");
			txt = txt.replace(/(\W)(кого-либо)/gi, "$1к-л.");

			txt = txt.replace(/(\W)(чему-л\.)/gi, "$1ч-л.");
			txt = txt.replace(/(\W)(чему-либо)/gi, "$1ч-л.");
			txt = txt.replace(/(\W)(кому-л\.)/gi, "$1к-л.");
			txt = txt.replace(/(\W)(кому-либо)/gi, "$1к-л.");

			txt = txt.replace(/(\W)(чем-л\.)/gi, "$1ч-л.");
			txt = txt.replace(/(\W)(чем-либо)/gi, "$1ч-л.");
			txt = txt.replace(/(\W)(кем-л\.)/gi, "$1к-л.");
			txt = txt.replace(/(\W)(кем-либо)/gi, "$1к-л.");

			txt = txt.replace(/(\W)(чём-л\.)/gi, "$1ч-л.");
			txt = txt.replace(/(\W)(чём-либо)/gi, "$1ч-л.");
			txt = txt.replace(/(\W)(ком-л\.)/gi, "$1к-л.");
			txt = txt.replace(/(\W)(ком-либо)/gi, "$1к-л.");
			txt = txt.replace(/(\W)(разг )/gi, "$1umg. ");
			txt = txt.replace(/(\W)(разг\.)/gi, "$1umg.");
			txt = txt.replace(/(\W)(перен )/gi, "$1перен. ");
			txt = txt.replace(/(\W)(уст )/gi, "$1уст. ");
			txt = txt.replace(/(\W)(устарев )/gi, "$1уст. ");
			txt = txt.replace(/(\W)(физ )/gi, "$1физ. ");
			txt = txt.replace(/(\W)(астр )/gi, "$1астр. ");
			txt = txt.replace(/(\W)(хим )/gi, "$1хим. ");
			txt = txt.replace(/(\W)(диал )/gi, "$1диал. ");
			txt = txt.replace(/(\W)(ист )/gi, "$1ист. ");
			txt = txt.replace(/(\W)(ав )/gi, "$1ав. ");
			txt = txt.replace(/(\W)(эл )/gi, "$1эл. ");
			txt = txt.replace(/(\W)(лингв )/gi, "$1лингв. ");
			txt = txt.replace(/(\W)(полит )/gi, "$1полит. ");
			txt = txt.replace(/(\W)(биол )/gi, "$1биол. ");
			txt = txt.replace(/(\W)(зоол )/gi, "$1зоол. ");
			txt = txt.replace(/(\W)(анат )/gi, "$1анат. ");
			txt = txt.replace(/(\W)(мед )/gi, "$1мед. ");
			txt = txt.replace(/(\W)(информ )/gi, "$1инф. ");
			txt = txt.replace(/(\W)(инф )/gi, "$1инф. ");
			txt = txt.replace(/(\W)(вчт )/gi, "$1инф. ");
			txt = txt.replace(/(\W)(комп )/gi, "$1инф. ");
			txt = txt.replace(/(\W)(фам )/gi, "$1фам. ");
			txt = txt.replace(/(\W)(геол )/gi, "$1геол. ");
			txt = txt.replace(/(\W)(социол )/gi, "$1социол. ");
			txt = txt.replace(/(\W)(тех )/gi, "$1тех. ");
			txt = txt.replace(/(\W)(рел )/gi, "$1рел. ");
			txt = txt.replace(/(\W)(мат )/gi, "$1мат. ");
			txt = txt.replace(/(\W)(матем )/gi, "$1мат. ");
			txt = txt.replace(/(\W)(стр )/gi, "$1стр. ");
			txt = txt.replace(/(\W)(эк )/gi, "$1эк. ");
			txt = txt.replace(/(\W)(юр )/gi, "$1юр. ");
			txt = txt.replace(/(\W)(кул )/gi, "$1кул. ");
			txt = txt.replace(/(\W)(стр )/gi, "$1стр. ");
			txt = txt.replace(/(\W)(театр )/gi, "$1театр. ");
			txt = txt.replace(/(\W)(груб )/gi, "$1груб. ");
			txt = txt.replace(/(\W)(высок )/gi, "$1высок. ");
			txt = txt.replace(/(\W)(презр )/gi, "$1презр. ");
			txt = txt.replace(/(\W)(канц )/gi, "$1канц. ");
			txt = txt.replace(/(\W)(геогр )/gi, "$1геогр. ");
			txt = txt.replace(/(\W)(воен )/gi, "$1воен. ");
			txt = txt.replace(/(\W)(бот )/gi, "$1бот. ");
			txt = txt.replace(/(\W)(напр )/gi, "$1напр. ");
			txt = txt.replace(/(\W)(психол )/gi, "$1психол. ");
			txt = txt.replace(/(\W)(муз )/gi, "$1муз. ");
			txt = txt.replace(/(\W)(шутл )/gi, "$1шутл. ");
			txt = txt.replace(/(\W)(неодобр )/gi, "$1неодобр. ");
			txt = txt.replace(/(\W)(спорт )/gi, "$1спорт. ");
			txt = txt.replace(/(\W)(англ )/gi, "$1англ. ");
			txt = txt.replace(/(\W)(фр )/gi, "$1фр. ");
			txt = txt.replace(/(\W)(мор )/gi, "$1мор. ");
			txt = txt.replace(/(\W)(библ )/gi, "$1библ. ");
			txt = txt.replace(/(\W)(полигр )/gi, "$1полигр. ");
			txt = txt.replace(/(\W)(охот )/gi, "$1охот. ");
			txt = txt.replace(/(\W)(фин )/gi, "$1фин. ");
			txt = txt.replace(/(\W)(ком )/gi, "$1ком. ");
			txt = txt.replace(/(\W)(филос )/gi, "$1филос. ");
			txt = txt.replace(/(\W)(редк )/gi, "$1редк. ");
			txt = txt.replace(/(\W)(книжн )/gi, "$1книжн. ");
			txt = txt.replace(/(\W)(театр )/gi, "$1театр. ");
			txt = txt.replace(/(\W)(кино )/gi, "$1кино. ");
			txt = txt.replace(/(\W)(с-х )/gi, "$1с-х. ");
			txt = txt.replace(/(\W)(поэт )/gi, "$1поэт. ");
			txt = txt.replace(/(\W)(неотд )/gi, "$1untren. ");
			txt = txt.replace(/(\W)(арх )/gi, "$1арх. ");
			txt = txt.replace(/(\W)(архит )/gi, "$1арх. ");
			txt = txt.replace(/(\W)(горн )/gi, "$1горн. ");
			txt = txt.replace(/(\W)(авт )/gi, "$1авт. ");
			txt = txt.replace(/(\W)(косм )/gi, "$1косм. ");

			txt = txt.replace(/( и т\. п\.)/gi, "");
			txt = txt.replace(/( {2,})/gi, " ");
			txt = txt.replace(/(;{2,})/gi, ";");
			txt = txt.replace(/(;)/gi, ",");
			txt = txt.replace(/(,{2,})/gi, ",");
			txt = txt.replace(/(,\n)/gi, "\n");
			if (txt && (txt.charAt(txt.length - 1) == "\n" || txt.charAt(txt.length - 1) == ":" || txt.charAt(txt.length - 1) == "," || txt.charAt(txt.length - 1) == ";"))
				txt = txt.substr(0, txt.length - 1);
			txt = txt.replace(/(,;|:;|;;|\n)/gi, ";");
			txt = txt.replace(/(;)/gi, ";\n");
			txt = txt.replace(/((,|:|;)+ *;)/gi, ";");
			txt = txt.replace(/(#)/gi, "");
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
				var row:String = rows[i].replace(/(\d+\) )/i, "");

				if (row && (row.charAt(row.length - 1) == "," || row.charAt(row.length - 1) == ":" || row.charAt(row.length - 1) == ";"))
					row = row.substr(0, row.length - 1);

				var number:String = (i + 1) + ")";
				res += number + " " + row;
				if (i < rows.length - 1)
					res += ";\n";
			}
		}
		else {
			res = txt;
		}
		return res;
	}

}
}