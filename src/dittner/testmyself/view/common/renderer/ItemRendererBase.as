package dittner.testmyself.view.common.renderer {
import dittner.testmyself.view.common.utils.TextFieldFactory;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.core.UIComponent;

import spark.components.IItemRenderer;

public class ItemRendererBase extends UIComponent implements IItemRenderer {

	public function ItemRendererBase() {
		super();
		percentWidth = 100;
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
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
		if (value != _selected) {
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

	protected function createTextField(textFormat:TextFormat, multiline:Boolean = false):TextField {
		return TextFieldFactory.create(textFormat, multiline);
	}

	private function addedToStageHandler(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		addEventListener(MouseEvent.MOUSE_OVER, overHandler);
		addEventListener(MouseEvent.MOUSE_OUT, outHandler);
	}

	protected function overHandler(event:MouseEvent):void {
		hovered = true;
	}

	protected function outHandler(event:MouseEvent):void {
		hovered = false;
	}

	private function removedFromStageHandler(event:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
		removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
}
}

