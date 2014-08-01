package dittner.testmyself.view.common.editor {
import dittner.testmyself.service.helpers.toolFactory.ToolInfo;

import flash.geom.Point;

import mx.collections.ArrayCollection;

public interface IEditor {

	function get toolInfo():ToolInfo;
	function set toolInfo(value:ToolInfo):void;

	function get arrowPos():Point;
	function set arrowPos(value:Point):void;

	function get themes():ArrayCollection;
	function set themes(value:ArrayCollection):void;
}
}
