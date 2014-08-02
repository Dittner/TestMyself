package dittner.testmyself.view.phrase.components {
import dittner.testmyself.model.vo.ThemeVo;

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
