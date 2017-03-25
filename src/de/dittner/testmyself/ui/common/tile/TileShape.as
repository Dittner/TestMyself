package de.dittner.testmyself.ui.common.tile {
import com.greensock.TweenLite;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Rectangle;

public class TileShape extends Shape {
	private static const ANIMATION_DURATION_IN_SEC:Number = 0.5;

	public function TileShape(tileID:String = "") {
		this.tileID = tileID;
		super();
	}

	private var tile:Tile;

	//--------------------------------------
	//  tileID
	//--------------------------------------
	protected var _tileID:String = "";
	public function get tileID():String {return _tileID;}
	public function set tileID(value:String):void {
		if (_tileID != value) {
			_tileID = value;
			updateData();
		}
	}

	private var explicitWidth:Number = NaN;
	override public function set width(value:Number):void {
		if (explicitWidth != value) {
			explicitWidth = value;
			super.width = value;
			updateData();
		}
	}

	private var explicitHeight:Number = NaN;
	override public function set height(value:Number):void {
		if (explicitHeight != value) {
			explicitHeight = value;
			super.height = value;
			updateData();
		}
	}

	private function updateData():void {
		var g:Graphics = graphics;
		g.clear();

		if (tileID) {
			if (!tile) tile = new Tile(tileID);
			else tile.id = tileID;

			var bd:BitmapData = tile.bitmapData;
			if (bd) {
				if (explicitWidth || explicitHeight) {
					var rect:Rectangle = new Rectangle(bd.width / 2 - 1, bd.height / 2 - 1, 2, 2);
					const gridX:Vector.<Number> = Vector.<Number>([rect.left, rect.right, bd.width]);
					const gridY:Vector.<Number> = Vector.<Number>([rect.top, rect.bottom, bd.height]);

					var leftPos:Number = 0;
					var i:int = 0;
					var j:int = 0;
					const n:uint = gridX.length;
					const m:uint = gridY.length;

					while (i < n) {
						j = 0;
						var topPos:Number = 0;
						while (j < m) {
							g.beginBitmapFill(bd, null, false, true);
							g.drawRect(leftPos, topPos, gridX[i] - leftPos, gridY[j] - topPos);
							g.endFill();

							topPos = gridY[j];
							j++;
						}
						leftPos = gridX[i];
						i++;
					}
					scale9Grid = rect;
				}
				else {
					g.beginBitmapFill(bd, null, false, true);
					g.drawRect(0, 0, bd.width, bd.height);
					g.endFill();
					scale9Grid = null;
				}
			}
		}
	}

	private var _alphaTo:Number = 1;
	public function get alphaTo():Number {return _alphaTo;}
	public function set alphaTo(value:Number):void {
		if (_alphaTo != value) {
			_alphaTo = value;
			startAlphaAnimation();
		}
	}

	private var isAnimating:Boolean = false;
	private var hasPendingAnimation:Boolean = false;
	private function startAlphaAnimation():void {
		if(!tileID) {
			alpha = alphaTo;
			return;
		}
		if (isAnimating) {
			hasPendingAnimation = true;
		}
		else {
			isAnimating = true;
			TweenLite.to(this, ANIMATION_DURATION_IN_SEC, {alpha: alphaTo, onComplete: animationComplete});
		}
	}

	private function animationComplete():void {
		isAnimating = false;
		if (hasPendingAnimation) {
			hasPendingAnimation = false;
			startAlphaAnimation();
		}
	}
}
}
