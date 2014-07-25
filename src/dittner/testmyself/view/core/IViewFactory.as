package dittner.testmyself.view.core {
public interface IViewFactory {
	function generate(viewId:uint):ViewBase;
	function generateFirstView():ViewBase;
	function get viewInfos():Array;
}
}
