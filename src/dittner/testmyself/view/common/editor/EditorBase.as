package dittner.testmyself.view.common.editor {
import dittner.testmyself.service.helpers.toolFactory.ToolInfo;

import flash.geom.Point;

import spark.components.SkinnableContainer;

public class EditorBase extends SkinnableContainer {

	public function EditorBase() {
		super();
		setStyle("skinClass", EditorBaseSkin);
	}

	//--------------------------------------
	//  toolInfo
	//--------------------------------------
	private var _toolInfo:ToolInfo;
	public function get toolInfo():ToolInfo {return _toolInfo;}
	public function set toolInfo(value:ToolInfo):void {
		if (_toolInfo != value) {
			_toolInfo = value;
		}
	}

	//--------------------------------------
	//  arrowPos
	//--------------------------------------
	private var _arrowPos:Point;
	public function get arrowPos():Point {return _arrowPos;}
	public function set arrowPos(value:Point):void {
		if (_arrowPos != value) {
			_arrowPos = value;
			if(skin) skin.invalidateDisplayList();
		}
	}

}
}
