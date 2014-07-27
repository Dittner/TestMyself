package dittner.testmyself.service.helpers.viewFactory {
import dittner.testmyself.view.core.ViewBase;

public interface IViewFactory {
	function generate(viewId:uint):ViewBase;
	function generateFirstView():ViewBase;
	function get viewInfos():Array;
}
}
