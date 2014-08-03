package dittner.testmyself.view.common.tooltip {
import flash.geom.Rectangle;

import mx.core.IUIComponent;

public interface IToolTip extends IUIComponent {
	function get text():String;
	function set text(value:String):void;

	function orient(globalBounds:Rectangle):void;
}
}
