package de.dittner.testmyself.ui.common.tile {
import com.greensock.TweenLite;

import flash.text.TextField;

public class FadeTextField extends TextField {
	public function FadeTextField() {
		super();
	}

	//--------------------------------------
	//  animationDuration
	//--------------------------------------
	private var _animationDuration:Number = 0.5;
	public function get animationDuration():Number {return _animationDuration;}
	public function set animationDuration(value:Number):void {
		if (_animationDuration != value) {
			_animationDuration = value;
		}
	}

	//--------------------------------------
	//  alphaTo
	//--------------------------------------
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
		if (isAnimating) {
			hasPendingAnimation = true;
		}
		else {
			isAnimating = true;
			TweenLite.to(this, animationDuration, {alpha: alphaTo, onComplete: animationComplete});
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
