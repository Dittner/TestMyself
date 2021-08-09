package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.ui.common.page.NotePage;

public class ViewInfo {
	public function ViewInfo(viewID:String = "", page:NotePage = null, menuViewID:String = "") {
		this.viewID = viewID;
		this.menuViewID = menuViewID;
		this.page = page;
	}

	public var viewID:String = "";
	public var menuViewID:String = "";
	public var page:NotePage;
}
}