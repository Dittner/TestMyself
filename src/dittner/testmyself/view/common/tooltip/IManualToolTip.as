package dittner.testmyself.view.common.tooltip {
import mx.core.IUIComponent;

public interface IManualToolTip extends IUIComponent {
	function get text():String;
	function set text(value:String):void;

	function orient(stageX:Number, stageY:Number, arrowDirection:String):void;
}
}
