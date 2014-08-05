package dittner.testmyself.view.phrase.common {
import dittner.testmyself.model.theme.ThemeVo;

public class ThemeRendererData {
	public function ThemeRendererData(theme:ThemeVo) {
		_theme = theme;
	}

	private var _theme:ThemeVo;
	public function get theme():ThemeVo {return _theme;}

	public var isNew:Boolean = false;
	public var isSeparator:Boolean = false;
	public var selected:Boolean = false;
}
}
