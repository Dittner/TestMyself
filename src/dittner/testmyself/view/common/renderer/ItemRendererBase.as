package dittner.testmyself.view.common.renderer {
import flash.text.TextField;

import mx.core.UIComponent;

import spark.components.IItemRenderer;

public class ItemRendererBase extends UIComponent implements IItemRenderer {

	public function ItemRendererBase() {
		super();
		percentWidth = 100;
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

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	protected function createTextField():TextField {
		var textField:TextField = new TextField();
		textField.selectable = false;
		textField.multiline = true;
		textField.wordWrap = true;
		textField.mouseEnabled = false;
		textField.mouseWheelEnabled = false;
		return textField;
	}

}
}

