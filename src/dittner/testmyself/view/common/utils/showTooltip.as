package dittner.testmyself.view.common.utils {
import dittner.testmyself.view.common.tooltip.CustomToolTipManager;

import mx.core.IUIComponent;

public function showTooltip(text:String, host:IUIComponent):void {
	CustomToolTipManager.instance.show(text, host);
}
}
