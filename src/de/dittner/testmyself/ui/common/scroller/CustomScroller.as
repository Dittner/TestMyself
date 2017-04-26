package de.dittner.testmyself.ui.common.scroller {
import de.dittner.testmyself.model.Device;

import spark.components.Group;
import spark.components.Scroller;

public class CustomScroller extends Scroller {
	public function CustomScroller() {
		super();
	}

	override protected function attachSkin():void {
		super.attachSkin();
		if(Device.isDesktop)
			Group(skin).layout = new CustomScrollerLayout();
	}
}
}
