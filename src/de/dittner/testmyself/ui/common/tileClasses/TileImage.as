package de.dittner.testmyself.ui.common.tileClasses {
import flash.display.Graphics;
import flash.events.Event;

import mx.core.UIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

public class TileImage extends UIComponent {
	public function TileImage() {
		super();
		bg = new TileShape();
		addChild(bg);
	}

	protected var bg:TileShape;

	//--------------------------------------
	//  use9Scale
	//--------------------------------------
	private var _use9Scale:Boolean = false;
	[Bindable("use9ScaleChanged")]
	public function get use9Scale():Boolean {return _use9Scale;}
	public function set use9Scale(value:Boolean):void {
		if (_use9Scale != value) {
			_use9Scale = value;
			invalidateDisplayList();
			dispatchEvent(new Event("use9ScaleChanged"));
		}
	}

	//--------------------------------------
	//  actualTileID
	//--------------------------------------
	private var _actualTileID:String = "";
	[Bindable("actualTileIDChanged")]
	public function get actualTileID():String {return _actualTileID;}
	public function set actualTileID(value:String):void {
		if (_actualTileID != value) {
			_actualTileID = value;
			updateTile();
			dispatchEvent(new Event("actualTileIDChanged"));
		}
	}

	//--------------------------------------
	//  shadowSize
	//--------------------------------------
	private var _shadowSize:Number = 0;
	[Bindable("shadowSizeChanged")]
	public function get shadowSize():Number {return _shadowSize;}
	public function set shadowSize(value:Number):void {
		if (_shadowSize != value) {
			_shadowSize = value;
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("shadowSizeChanged"));
		}
	}

	override public function set enabled(value:Boolean):void {
		if (super.enabled != value) {
			super.enabled = value;
			super.mouseEnabled = enabled && _mouseEnabled;
			super.mouseChildren = enabled && _mouseChildren;
		}
	}

	private var _mouseEnabled:Boolean = true;
	override public function set mouseEnabled(value:Boolean):void {
		if(_mouseEnabled != value) {
			_mouseEnabled = value;
			super.mouseEnabled = enabled && _mouseEnabled;
		}
	}

	private var _mouseChildren:Boolean = true;
	override public function set mouseChildren(value:Boolean):void {
		if(_mouseChildren != value) {
			_mouseChildren = value;
			super.mouseChildren = enabled && _mouseChildren;
		}
	}

	[PercentProxy("percentHeight")]
	[Inspectable(category="General")]
	[Bindable("heightChanged")]
	override public function get height():Number {
		return super.height ? super.height : measuredHeight;
	}

	[PercentProxy("percentWidth")]
	[Inspectable(category="General")]
	[Bindable("widthChanged")]
	override public function get width():Number {
		return super.width ? super.width : measuredWidth;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	protected function updateTile():void {
		var lastWidth:Number = bg.width;
		var lastHeight:Number = bg.height;
		bg.tileID = actualTileID;
		if (lastWidth != bg.width || lastHeight != bg.height) {
			invalidateSize();
			invalidateDisplayList();
		}
	}

	override protected function measure():void {
		super.measure();
		measuredWidth = bg.width - 2 * shadowSize;
		measuredHeight = bg.height - 2 * shadowSize;
	}

	override public function validateDisplayList():void {
		oldLayoutDirection = layoutDirection;
		if (invalidateDisplayListFlag) {
			setActualSize(width || measuredWidth, height || measuredHeight);
			validateMatrix();

			var unscaledWidth:Number = width || measuredWidth;
			var unscaledHeight:Number = height || measuredHeight;

			updateDisplayList(unscaledWidth, unscaledHeight);
			invalidateDisplayListFlag = false;
		}
		else {
			validateMatrix();
		}
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		alpha = enabled ? 1 : 0.5;

		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0, 0.0000001);
		g.drawRect(0, 0, w, h);
		g.endFill();

		if (w != 0 && h != 0) {
			bg.x = -shadowSize;
			bg.y = -shadowSize;
			if (use9Scale) {
				bg.width = w + 2 * shadowSize;
				bg.height = h + 2 * shadowSize;
			}
			else {
				bg.width = NaN;
				bg.height = NaN;
			}
		}
	}

}
}
