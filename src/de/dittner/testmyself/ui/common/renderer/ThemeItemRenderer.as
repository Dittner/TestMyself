package de.dittner.testmyself.ui.common.renderer {
import de.dittner.testmyself.model.domain.theme.ITheme;

public class ThemeItemRenderer extends StringItemRenderer {

	public function ThemeItemRenderer() {
		super();
	}

	override protected function get text():String {
		return data is ITheme ? (data as ITheme).name : "";
	}
}
}
