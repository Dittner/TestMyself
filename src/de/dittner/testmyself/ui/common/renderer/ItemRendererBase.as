package de.dittner.testmyself.ui.common.renderer {
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.ui.common.list.SelectableDataGroup;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.collections.IList;
import mx.core.UIComponent;

import spark.components.IItemRenderer;
import spark.components.List;

public class ItemRendererBase extends UIComponent implements IItemRenderer {

	public function ItemRendererBase() {
		super();
		percentWidth = 100;
		if (Device.isDesktop) addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	//----------------------------------
	//  data
	//----------------------------------
	protected var dataChanged:Boolean = false;
	private var _data:Object;
	public function get data():Object {return _data;}
	public function set data(value:Object):void {
		if (_data != value) {
			_data = value;
			dataChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
	}

	//----------------------------------
	//  label
	//----------------------------------
	public function set label(value:String):void {}
	public function get label():String { return ""; }

	//----------------------------------
	//  itemIndex
	//----------------------------------
	private var _itemIndex:int;
	public function get itemIndex():int {return _itemIndex;}
	public function set itemIndex(value:int):void {
		_itemIndex = value;
	}

	//--------------------------------------
	//  isLastItem
	//--------------------------------------
	public function get isLastItem():Boolean {
		var dataProvider:IList;
		if (parent is SelectableDataGroup) {
			dataProvider = (parent as SelectableDataGroup).dataProvider;
		}
		else if (parent is List) {
			dataProvider = (parent as List).dataProvider;
		}
		return dataProvider && dataProvider.length > 0 && data == dataProvider[dataProvider.length - 1];
	}

	//----------------------------------
	//  dragging
	//----------------------------------
	public function get dragging():Boolean {return false}
	public function set dragging(value:Boolean):void {}

	//----------------------------------
	//  showsCaret
	//----------------------------------
	public function get showsCaret():Boolean {return false}
	public function set showsCaret(value:Boolean):void {}

	//----------------------------------
	//  selected
	//----------------------------------
	private var _selected:Boolean = false;
	public function get selected():Boolean {return _selected;}
	public function set selected(value:Boolean):void {
		if (_selected != value) {
			_selected = value;
			invalidateDisplayList();
		}
	}

	//--------------------------------------
	//  hovered
	//--------------------------------------
	private var _hovered:Boolean;
	[Bindable("hoveredChanged")]
	public function get hovered():Boolean {return _hovered;}
	public function set hovered(value:Boolean):void {
		if (_hovered != value) {
			_hovered = value;
			invalidateDisplayList();
			dispatchEvent(new Event("hoveredChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	protected function createTextField(textFormat:TextFormat):TextField {
		return TextFieldFactory.create(textFormat);
	}

	protected function createMultilineTextField(textFormat:TextFormat):TextField {
		return TextFieldFactory.createMultiline(textFormat);
	}

	private function addedToStageHandler(event:Event):void {
		if (Device.isDesktop) {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		}
	}

	protected function overHandler(event:MouseEvent):void {
		hovered = true;
	}

	protected function outHandler(event:MouseEvent):void {
		hovered = false;
	}

	private function removedFromStageHandler(event:Event):void {
		if (Device.isDesktop) {
			hovered = false;
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
	}
}
}

