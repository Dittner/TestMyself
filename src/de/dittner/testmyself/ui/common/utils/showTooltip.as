package de.dittner.testmyself.ui.common.utils {
import de.dittner.testmyself.ui.common.tooltip.CustomToolTipManager;

import mx.core.IUIComponent;

public function showTooltip(text:String, host:IUIComponent):void {
	CustomToolTipManager.instance.show(text, host);
}
}
