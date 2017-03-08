package de.dittner.testmyself.ui.common.list {
import com.greensock.TweenLite;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.IList;
import mx.collections.ListCollectionView;
import mx.core.IVisualElement;
import mx.core.UIComponent;

import spark.components.DataGroup;
import spark.components.IItemRenderer;
import spark.events.RendererExistenceEvent;

[Event(name="dataProviderChanged", type="flash.events.Event")]
[Event(name="selectedItemChange", type="flash.events.Event")]
public class SelectableDataGroup extends DataGroup {

	public static const SELECTED:String = "selectedItemChange";

	public function SelectableDataGroup() {
		super();
		addEventListener(RendererExistenceEvent.RENDERER_ADD, rendererAddHandler);
		addEventListener(RendererExistenceEvent.RENDERER_REMOVE, rendererRemoveHandler);
	}

	protected var renderers:Array = [];
	protected var selectedRenderer:IItemRenderer;

	//--------------------------------------------------------------------------
	//
	//  Getter/setter
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------------
	//  selectedIndex
	//--------------------------------------------------------------------------------
	[Bindable("selectedItemChange")]
	public function get selectedIndex():int {
		if (!_selectedItem || !dataProvider) return -1;
		return dataProvider.getItemIndex(_selectedItem);
	}
	public function set selectedIndex(value:int):void {
		if (dataProvider) selectedItem = dataProvider.getItemAt(value);
	}

	//--------------------------------------------------------------------------------
	//  selectedItem
	//--------------------------------------------------------------------------------
	private var _selectedItem:Object;
	[Bindable("selectedItemChange")]
	public function get selectedItem():Object {return _selectedItem;}
	public function set selectedItem(value:Object):void {
		if (value == _selectedItem) {
			if (allowSelectLastItem) notifySelectedItemChanged();
			return;
		}

		_selectedItem = value;
		var n:int = numElements;
		selectedRenderer = null;
		for (var i:int = 0; i < n; i++) {
			var renderer:IItemRenderer = getElementAt(i) as IItemRenderer;
			if (renderer) {
				if (renderer.data == value) {
					renderer.selected = true;
					selectedRenderer = renderer;
				}
				else {
					renderer.selected = false;
				}
			}
		}
		notifySelectedItemChanged();
	}

	override public function set dataProvider(value:IList):void {
		if (super.dataProvider != value) {
			selectedItem = null;
			super.dataProvider = value;
		}
	}

	protected function notifySelectedItemChanged():void {
		dispatchEvent(new Event("selectedItemChange"));
	}

	//--------------------------------------------------------------------------------
	//  allowSelectByClick
	//--------------------------------------------------------------------------------
	private var _allowSelectByClickChanged:Boolean = false;
	private var _haveRenderersClickListeners:Boolean = true;
	private var _allowSelectByClick:Boolean = true;
	[Bindable("allowSelectByClickChange")]
	public function get allowSelectByClick():Boolean {return _allowSelectByClick;}
	public function set allowSelectByClick(value:Boolean):void {
		if (value == _allowSelectByClick)return;
		_allowSelectByClick = value;
		_allowSelectByClickChanged = true;
		invalidateProperties();
	}

	//--------------------------------------------------------------------------------
	//  allowSelectLastItem
	//--------------------------------------------------------------------------------
	private var _allowSelectLastItem:Boolean = false;
	public function get allowSelectLastItem():Boolean {return _allowSelectLastItem;}
	public function set allowSelectLastItem(value:Boolean):void {
		_allowSelectLastItem = value;
	}

	//--------------------------------------
	//  deselectEnabled
	//--------------------------------------
	private var _deselectEnabled:Boolean = false;
	[Bindable("deselectEnabledChanged")]
	public function get deselectEnabled():Boolean {return _deselectEnabled;}
	public function set deselectEnabled(value:Boolean):void {
		if (_deselectEnabled != value) {
			_deselectEnabled = value;
			dispatchEvent(new Event("deselectEnabledChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function commitProperties():void {
		super.commitProperties();
		if (_allowSelectByClickChanged) {
			_allowSelectByClickChanged = false;
			if (allowSelectByClick) {
				addEventListener(RendererExistenceEvent.RENDERER_ADD, rendererAddHandler);
				if (!_haveRenderersClickListeners) addClickListeners();
				_haveRenderersClickListeners = true;
			}
			else {
				removeEventListener(RendererExistenceEvent.RENDERER_ADD, rendererAddHandler);
				if (_haveRenderersClickListeners) removeClickListeners();
				_haveRenderersClickListeners = false;
			}
		}
	}

	override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void {
		super.updateRenderer(renderer, itemIndex, data);
		if (!allowSelectLastItem && renderer is IItemRenderer)
			IItemRenderer(renderer).selected = (data == _selectedItem);
	}

	protected function addClickListeners():void {
		for (var i:int = 0; i < numElements; i++) {
			var renderer:IItemRenderer = getElementAt(i) as IItemRenderer;
			renderer.addEventListener(MouseEvent.CLICK, renderer_clickHandler);
		}
	}

	protected function removeClickListeners():void {
		for (var i:int = 0; i < numElements; i++) {
			var renderer:IItemRenderer = getElementAt(i) as IItemRenderer;
			renderer.removeEventListener(MouseEvent.CLICK, renderer_clickHandler);
		}
	}

	public function ensureSelectedItemIsVisible():void {
		if (height < measuredHeight && selectedRenderer) {

			var vspTo:Number = verticalScrollPosition;

			if (vspTo + height < selectedRenderer.y + getRendererActualHeight(selectedRenderer))
				vspTo = selectedRenderer.y + getRendererActualHeight(selectedRenderer) - height + 70;
			if (vspTo > selectedRenderer.y)
				vspTo = selectedRenderer.y;
			if (vspTo > measuredHeight - height)
				vspTo = measuredHeight - height;

			if (vspTo != verticalScrollPosition)
				TweenLite.to(this, 0.5, {verticalScrollPosition: vspTo});
		}
	}

	private function getRendererActualHeight(ren:IItemRenderer):Number {
		return ren is UIComponent ? (ren as UIComponent).measuredHeight : ren.height;
	}

	//--------------------------------------------------------------------------
	//
	//  Handlers
	//
	//--------------------------------------------------------------------------

	protected function rendererAddHandler(event:RendererExistenceEvent):void {
		renderers.push(event.renderer);
		event.renderer.addEventListener(MouseEvent.CLICK, renderer_clickHandler);
	}

	protected function rendererRemoveHandler(event:RendererExistenceEvent):void {
		var ind:int = renderers.indexOf(event.renderer);
		if (ind != -1) renderers.splice(ind, 1);
		event.renderer.removeEventListener(MouseEvent.CLICK, renderer_clickHandler);
		if (dataProvider is ListCollectionView)(dataProvider as ListCollectionView).refresh();
	}

	protected function renderer_clickHandler(event:MouseEvent):void {
		var dataRenderer:IItemRenderer = event.currentTarget as IItemRenderer;
		var selectedData:Object = dataRenderer ? dataRenderer.data : null;
		if (deselectEnabled && selectedData && selectedData == selectedItem)
			selectedItem = null;
		else
			selectedItem = selectedData;
	}
}
}