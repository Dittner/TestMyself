package de.dittner.testmyself.ui.view.noteList.common.toolbar {
public class ToolActionName {
	private static const hash:Object = createNameHash();

	private static function createNameHash():Object {
		var names:Object = {};
		names[ToolAction.CREATE_NOTE] = "Hinzufügen";
		names[ToolAction.EDIT_NOTE] = "Bearbeiten";
		names[ToolAction.REMOVE_NOTE] = "Entfernen";
		names[ToolAction.INVERT] = "Invertieren";
		names[ToolAction.FILTER] = "Filtern";
		return names;
	}

	public static function getNameByID(toolID:String):String {
		return hash[toolID] || "";
	}
}
}
