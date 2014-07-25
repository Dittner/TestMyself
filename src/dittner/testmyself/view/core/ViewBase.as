package dittner.testmyself.view.core {
import spark.components.SkinnableContainer;

use namespace view_internal;

public class ViewBase extends SkinnableContainer {
	public function ViewBase() {
		super();
		setStyle("skinClass", ViewBaseSkin);
	}

	//--------------------------------------
	//  info
	//--------------------------------------
	view_internal var _info:ViewInfo;
	public function get info():ViewInfo {return _info;}

}
}
