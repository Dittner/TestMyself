package dittner.testmyself.view.phrase.common {
import dittner.testmyself.model.theme.Theme;

public class ThemeRendererData {
	public function ThemeRendererData(theme:Theme) {
		_theme = theme;
	}

	private var _theme:Theme;
	public function get theme():Theme {return _theme;}

	public var isNew:Boolean = false;
	public var isSeparator:Boolean = false;
	public var selected:Boolean = false;
}
}
