package de.dittner.testmyself.ui.common.toobar {
public class ToolActionName {
	private static const hash:Object = createNameHash();

	private static function createNameHash():Object {
		var names:Object = {};
		names[ToolAction.ADD] = "Hinzufügen";
		names[ToolAction.EDIT] = "Bearbeiten";
		names[ToolAction.REMOVE] = "Entfernen";
		names[ToolAction.INVERT] = "Invertieren";
		names[ToolAction.FILTER] = "Filtern";
		return names;
	}

	public static function getNameById(toolId:String):String {
		return hash[toolId] || "";
	}
}
}
