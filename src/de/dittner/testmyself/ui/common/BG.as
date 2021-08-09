package de.dittner.testmyself.ui.common {

import flash.display.Graphics;
import flash.events.Event;

import spark.core.SpriteVisualElement;

public class BG extends SpriteVisualElement {
	public function BG() {
		super();
	}

	//--------------------------------------
	//  fillColor
	//--------------------------------------
	private var _fillColor:uint = 0xffFFff;
	[Bindable("fillColorChanged")]
	public function get fillColor():uint {return _fillColor;}
	public function set fillColor(value:uint):void {
		if (_fillColor != value) {
			_fillColor = value;
			redraw();
			dispatchEvent(new Event("fillColorChanged"));
		}
	}

	//--------------------------------------
	//  fillAlpha
	//--------------------------------------
	private var _fillAlpha:Number = 1;
	[Bindable("fillAlphaChanged")]
	public function get fillAlpha():Number {return _fillAlpha;}
	public function set fillAlpha(value:Number):void {
		if (_fillAlpha != value) {
			_fillAlpha = value;
			redraw();
			dispatchEvent(new Event("fillAlphaChanged"));
		}
	}

	//--------------------------------------
	//  borderColor
	//--------------------------------------
	private var _borderColor:uint = 0;
	[Bindable("borderColorChanged")]
	public function get borderColor():uint {return _borderColor;}
	public function set borderColor(value:uint):void {
		if (_borderColor != value) {
			_borderColor = value;
			redraw();
			dispatchEvent(new Event("borderColorChanged"));
		}
	}

	//--------------------------------------
	//  borderWeight
	//--------------------------------------
	private var _borderWeight:uint = 0;
	[Bindable("borderWeightChanged")]
	public function get borderWeight():uint {return _borderWeight;}
	public function set borderWeight(value:uint):void {
		if (_borderWeight != value) {
			_borderWeight = value;
			redraw();
			dispatchEvent(new Event("borderWeightChanged"));
		}
	}

	override public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean = true):void {
		super.setLayoutBoundsSize(width, height, postLayoutTransform);
		redraw();
	}

	private function redraw():void {
		var g:Graphics = graphics;
		g.clear();

		if (width > 0 && height > 0) {
			var w:Number = Math.ceil(width);
			var h:Number = Math.ceil(height);

			g.beginFill(fillColor, fillAlpha);
			g.drawRect(0, 0, w, h);
			g.endFill();

			if (borderWeight > 0) {
				g.beginFill(borderColor);
				g.drawRect(0, 0, w, 1);
				g.endFill();

				g.beginFill(borderColor);
				g.drawRect(0, h - 1, w, 1);
				g.endFill();

				g.beginFill(borderColor);
				g.drawRect(0, 0, 1, h);
				g.endFill();

				g.beginFill(borderColor);
				g.drawRect(w - 1, 0, 1, h);
				g.endFill();
			}
		}
	}
}
}
