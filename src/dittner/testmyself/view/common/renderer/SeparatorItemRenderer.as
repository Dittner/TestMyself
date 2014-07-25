package dittner.testmyself.view.common.renderer {
import flash.display.Graphics;

public class SeparatorItemRenderer extends ItemRendererBase {

	public function SeparatorItemRenderer() {
		super();
		mouseEnabled = mouseChildren = false;
	}

	private function get separator():SeparatorVo {
		return data as SeparatorVo;
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : 0;
		measuredHeight = measuredMinHeight = separator ? separator.thickness + separator.gap * 2 : 0;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		if (separator) {
			g.beginFill(separator.color, separator.alpha);
			g.drawRect(0, separator.gap, w, separator.thickness);
			g.endFill();
		}
	}

}
}
