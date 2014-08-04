package dittner.testmyself.view.common.toobar {
public class ToolActionName {
	private static const hash:Object = createNameHash();

	private static function createNameHash():Object {
		var names:Object = {};
		names[ToolAction.ADD] = "Добавить";
		names[ToolAction.EDIT] = "Редактировать";
		names[ToolAction.REMOVE] = "Удалить";
		names[ToolAction.TRANS_INVERT] = "Инвертировать";
		names[ToolAction.FILTER] = "Фильтровать";
		return names;
	}

	public static function getNameById(toolId:String):String {
		return hash[toolId] || "";
	}
}
}
