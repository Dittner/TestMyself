package de.dittner.testmyself.ui.common.scroller {
import spark.components.Group;
import spark.components.Scroller;

public class CustomScroller extends Scroller {
	public function CustomScroller() {
		super();
	}

	override protected function attachSkin():void {
		super.attachSkin();
		Group(skin).layout = new CustomScrollerLayout();
	}
}
}
