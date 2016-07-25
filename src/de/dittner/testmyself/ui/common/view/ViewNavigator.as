package de.dittner.testmyself.ui.common.view {
import de.dittner.walter.WalterProxy;
import de.dittner.walter.walter_namespace;

use namespace walter_namespace;

public class ViewNavigator extends WalterProxy {
	public static const SELECTED_VIEW_CHANGED_MSG:String = "selectedViewChangedMsg";
	public function ViewNavigator() {
		super();
	}

	[Inject]
	public var viewFactory:IViewFactory;

	//--------------------------------------
	//  selectedView
	//--------------------------------------
	private var _selectedView:ViewBase;
	public function get selectedView():ViewBase {return _selectedView;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function navigate(viewInfo:ViewInfo):void {
		if (_selectedView) _selectedView.invalidate(NavigationPhase.VIEW_REMOVE);
		_selectedView = viewFactory.createView(viewInfo);
		_selectedView.invalidate(NavigationPhase.VIEW_ACTIVATE);

		sendMessage(SELECTED_VIEW_CHANGED_MSG, selectedView);
	}

	override protected function activate():void {}

	override protected function deactivate():void {}

}
}