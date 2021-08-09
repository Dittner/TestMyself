package de.dittner.testmyself.ui.common.audio.components {
import com.greensock.TweenLite;

import de.dittner.testmyself.ui.common.tile.TileID;
import de.dittner.testmyself.ui.common.tile.TileShape;
import de.dittner.testmyself.utils.Values;

import flash.events.Event;

import mx.core.UIComponent;

public class MicrophoneIcon extends UIComponent {
	private static const ANIMATION_DURATION_IN_SEC:Number = 1;

	public function MicrophoneIcon() {
		super();
		mouseFocusEnabled = mouseFocusEnabled = mouseChildren = false;
	}

	private var microphoneShape:TileShape;
	private var recShape:TileShape;

	//--------------------------------------
	//  areWavesShown
	//--------------------------------------
	private var _areWavesShown:Boolean = false;
	[Bindable("areWavesShownChanged")]
	public function get areWavesShown():Boolean {return _areWavesShown;}
	public function set areWavesShown(value:Boolean):void {
		if (_areWavesShown != value) {
			_areWavesShown = value;
			invalidateProperties();
			dispatchEvent(new Event("areWavesShownChanged"));
		}
	}

	override protected function createChildren():void {
		super.createChildren();
		if (!microphoneShape) {
			microphoneShape = new TileShape(TileID.MICROPHONE_ICON);
			addChild(microphoneShape);
		}

		if (!recShape) {
			recShape = new TileShape(TileID.MICROPHONE_REC_ICON);
			addChild(recShape);
		}
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (areWavesShown)
			startAlphaAnimation();
	}

	override protected function measure():void {
		measuredWidth = recShape.width + Values.PT5 + microphoneShape.measuredWidth;
		measuredHeight = Math.max(microphoneShape.measuredHeight, recShape.measuredHeight);
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		recShape.x = 0;
		recShape.y = h - recShape.measuredHeight >> 1;
		microphoneShape.x = recShape.measuredWidth + Values.PT5;
	}

	private var isAnimating:Boolean = false;
	private function startAlphaAnimation():void {
		if (!isAnimating) {
			isAnimating = true;
			var alphaTo:Number = recShape.alpha == 0 ? 1 : 0;
			TweenLite.to(recShape, ANIMATION_DURATION_IN_SEC, {alpha: alphaTo, onComplete: animationComplete});
		}
	}

	private function animationComplete():void {
		isAnimating = false;
		if (areWavesShown) {
			startAlphaAnimation();
		}
	}
}
}
