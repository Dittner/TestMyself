package de.dittner.testmyself.ui.view.search.components {
import de.dittner.testmyself.ui.view.noteList.components.renderer.NoteRenderer;

public class FoundNoteRenderer extends NoteRenderer {
	public function FoundNoteRenderer() {
		super();
	}

	public static var _searchingText:String = "";
	public static var pattern:RegExp;
	public static function set searchingText(value:String):void {
		if (_searchingText != value) {
			_searchingText = value;
			pattern = new RegExp(_searchingText, "gi");
		}
	}

	override protected function getTitle():String {
		var res:String = super.getTitle();
		return res.replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>');
	}

	override protected function getDescription():String {
		var res:String = super.getDescription();
		return res.replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>');
	}

}
}
