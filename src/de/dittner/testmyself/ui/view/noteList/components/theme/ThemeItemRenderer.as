package de.dittner.testmyself.ui.view.noteList.components.theme {
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.ui.common.renderer.*;

public class ThemeItemRenderer extends StringItemRenderer {

	public function ThemeItemRenderer() {
		super();
	}

	override protected function get text():String {
		return data is Theme ? (data as Theme).name : "";
	}
}
}
