package de.dittner.testmyself.ui.common.scroller {
import spark.components.Group;
import spark.components.Scroller;
import spark.components.supportClasses.ScrollerLayout;

public class CustomScroller extends Scroller {
	public function CustomScroller() {
		super();
	}

	override protected function attachSkin():void {
		super.attachSkin();
		Group(skin).layout = new ScrollerLayout();
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		if (w > 0 && viewport)
			viewport.width = w;
	}
}
}
