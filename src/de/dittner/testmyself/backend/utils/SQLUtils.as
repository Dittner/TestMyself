package de.dittner.testmyself.backend.utils {
import de.dittner.testmyself.model.domain.tag.Tag;

import flash.data.SQLStatement;

public class SQLUtils {
	public static function tagsToSqlStr(tags:Array):String {
		var res:String = "(";
		for (var i:int = 0; i < tags.length; i++) {
			var tag:Tag = tags[i] as Tag;
			res += "'" + tag.name + "'";
			if (i < tags.length - 1) res += ","
		}
		res += ")";
		return res;
	}

	public static function idsToSqlStr(ids:Array):String {
		if (!ids || ids.length == 0) return "";

		var res:String = "(";
		for (var i:int = 0; i < ids.length; i++) {
			var id:int = ids[i] as int;
			res += id;
			if (i < ids.length - 1) res += ","
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
