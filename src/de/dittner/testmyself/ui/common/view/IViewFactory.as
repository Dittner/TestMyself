package de.dittner.testmyself.ui.common.view {
import mx.collections.ArrayCollection;

public interface IViewFactory {
	function createView(viewInfo:ViewInfo):ViewBase;
	function get viewInfoColl():ArrayCollection;
}
}
