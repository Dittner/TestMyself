package de.dittner.testmyself.ui.common {
import flash.display.Graphics;

import spark.core.SpriteVisualElement;

public class Separator extends SpriteVisualElement {
	public function Separator() {
		super();
	}

	private var _color:uint = 0xffFFff;
	public function get color():uint {return _color;}
	public function set color(value:uint):void {
		if (_color != value) {
			_color = value;
			redraw();
		}
	}

	//--------------------------------------
	//  colors
	//--------------------------------------
	private var _colors:Array;
	public function get colors():Array {return _colors;}
	public function set colors(value:Array):void {
		if (_colors != value) {
			_colors = value;
			redraw();
		}
	}

	//--------------------------------------
	//  paddingLeft
	//--------------------------------------
	private var _paddingLeft:Number = 0;
	public function get paddingLeft():Number {return _paddingLeft;}
	public function set paddingLeft(value:Number):void {
		if (_paddingLeft != value) {
			_paddingLeft = value;
			redraw();
		}
	}
	//--------------------------------------
	//  paddingTop
	//--------------------------------------
	private var _paddingTop:Number = 0;
	public function get paddingTop():Number {return _paddingTop;}
	public function set paddingTop(value:Number):void {
		if (_paddingTop != value) {
			_paddingTop = value;
			redraw();
		}
	}

	//--------------------------------------
	//  paddingBottom
	//--------------------------------------
	private var _paddingBottom:Number = 0;
	[Bindable("paddingBottomChanged")]
	public function get paddingBottom():Number {return _paddingBottom;}
	public function set paddingBottom(value:Number):void {
		if (_paddingBottom != value) {
			_paddingBottom = value;
			redraw();
		}
	}

	override public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean = true):void {
		super.setLayoutBoundsSize(width, height, postLayoutTransform);
		redraw();
	}

	private function redraw():void {
		var g:Graphics = graphics;
		g.clear();
		var isHorizontal:Boolean = width >= height;

		if (colors) {
			for (var i:int = 0; i < colors.length; i++) {
				var colorItem:uint = colors[i];
				g.lineStyle(1, colorItem);
				if (isHorizontal) {
					g.moveTo(paddingLeft, i + paddingTop);
					g.lineTo(width, i - paddingBottom);
				}
				else {
					g.moveTo(i + paddingLeft, paddingTop);
					g.lineTo(i, height - paddingBottom);
				}
			}
		}
		else {
			g.lineStyle(1, color);
			if (isHorizontal) {
				g.moveTo(paddingLeft, paddingTop);
				g.lineTo(width, -paddingBottom);
			}
			else {
				g.moveTo(paddingLeft, paddingTop);
				g.lineTo(0, height - paddingBottom);
			}
		}
	}
}
}
