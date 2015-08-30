package dittner.testmyself.core.command.backend.utils {
import dittner.testmyself.core.model.theme.Theme;

import flash.data.SQLStatement;

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

	public static function createSQLStatement(sqlText:String, params:Object = null):SQLStatement {
		var stmt:SQLStatement = new SQLStatement();
		stmt.text = sqlText;
		if (params)
			for (var prop:String in params) stmt.parameters[":" + prop] = params[prop];
		return stmt;
	}
}
}
