package dittner.testmyself.view.core {
import dittner.testmyself.service.helpers.viewFactory.ViewInfo;
import dittner.testmyself.view.common.SelectableDataGroup;
import dittner.testmyself.view.common.renderer.ToolItemRenderer;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.core.ClassFactory;

import spark.components.SkinnableContainer;

use namespace view_internal;

public class ViewBase extends SkinnableContainer {
	public function ViewBase() {
		super();
		setStyle("skinClass", ViewBaseSkin);
		_toolItemRenderer = new ClassFactory(ToolItemRenderer);
	}

	[Bindable]
	[SkinPart(required="true")]
	public var toolPanel:SelectableDataGroup;

	//--------------------------------------
	//  info
	//--------------------------------------
	view_internal var _info:ViewInfo;
	public function get info():ViewInfo {return _info;}

	public var showHeader:Boolean = true;
	public var showBackground:Boolean = true;
	public var headerHeight:int = 35;

	//--------------------------------------
	//  tools
	//--------------------------------------
	private var _toolProvider:ArrayCollection;
	[Bindable("toolsChanged")]
	public function get toolProvider():ArrayCollection {return _toolProvider;}
	public function set toolProvider(value:ArrayCollection):void {
		if (_toolProvider != value) {
			_toolProvider = value;
			if (toolPanel) toolPanel.dataProvider = _toolProvider;
			dispatchEvent(new Event("toolsChanged"));
		}
	}

	//--------------------------------------
	//  toolItemRenderer
	//--------------------------------------
	private var _toolItemRenderer:ClassFactory;
	[Bindable("toolItemRendererChanged")]
	public function get toolItemRenderer():ClassFactory {return _toolItemRenderer;}
	public function set toolItemRenderer(value:ClassFactory):void {
		if (_toolItemRenderer != value) {
			_toolItemRenderer = value;
			if (toolPanel) toolPanel.itemRenderer = _toolItemRenderer;
			dispatchEvent(new Event("toolItemRendererChanged"));
		}
	}

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);
		if (instance == toolPanel) {
			toolPanel.itemRenderer = toolItemRenderer;
			toolPanel.dataProvider = toolProvider;
		}
	}

}
}
