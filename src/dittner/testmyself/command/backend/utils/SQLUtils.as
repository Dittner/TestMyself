package dittner.testmyself.command.backend.utils {
import dittner.testmyself.model.theme.Theme;

public class SQLUtils {
	public static function themesToSqlStr(themes:Array):String {
		var res:String = "(";
		for (var i:int = 0; i < themes.length; i++) {
			var theme:Theme = themes[i] as Theme;
			res += "'" + theme.name + "'";
			if (i < themes.length - 1) res += ","
		}
		res += ")";
		return res;
	}
}
}
