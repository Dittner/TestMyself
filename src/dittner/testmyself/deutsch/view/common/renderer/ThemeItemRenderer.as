package dittner.testmyself.deutsch.view.common.renderer {
import dittner.testmyself.core.model.theme.ITheme;

public class ThemeItemRenderer extends StringItemRenderer {

	public function ThemeItemRenderer() {
		super();
	}

	override protected function get text():String {
		return data is ITheme ? (data as ITheme).name : "";
	}
}
}
