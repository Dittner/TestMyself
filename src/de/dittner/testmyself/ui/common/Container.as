package de.dittner.testmyself.ui.common {
import com.greensock.TweenLite;

import flash.events.Event;

import mx.events.FlexEvent;

import spark.components.Group;

public class Container extends Group {
	private static const ANIMATION_DURATION:Number = 0.3;

	public function Container() {
		super();
	}

	//--------------------------------------
	//  moveDirectionWhenHiding
	//--------------------------------------
	private var _moveDirectionWhenHiding:String = "left";
	[Inspectable(category="General", enumeration="left,right", defaultValue="left")]
	[Bindable("moveDirectionWhenHidingChanged")]
	public function get moveDirectionWhenHiding():String {return _moveDirectionWhenHiding;}
	public function set moveDirectionWhenHiding(value:String):void {
		if (_moveDirectionWhenHiding != value) {
			_moveDirectionWhenHiding = value;
			invalidateDisplayList();
			dispatchEvent(new Event("moveDirectionWhenHidingChanged"));
		}
	}

	private var visibleChanged:Boolean = false;
	private var _visible:Boolean = true;
	[Inspectable(category="General", defaultValue="true")]
	[Bindable("show")]
	[Bindable("hide")]
	override public function get visible():Boolean {return _visible;}
	override public function set visible(value:Boolean):void {
		if (_visible != value) {
			_visible = value;
			var eventType:String = value ? FlexEvent.SHOW : FlexEvent.HIDE;
			mouseChildren = mouseFocusEnabled = mouseEnabled = visible;
			visibleChanged = true;
			invalidateProperties();
			invalidateDisplayList();
			if (hasEventListener(eventType))
				dispatchEvent(new FlexEvent(eventType));
		}
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (visibleChanged) {
			visibleChanged = false;
			startMoveAnimation();
		}
	}

	private var isAnimating:Boolean = false;
	private var hasPendingAnimation:Boolean = false;
	private function startMoveAnimation():void {
		if (isAnimating) {
			hasPendingAnimation = true;
		}
		else {
			var xFrom:Number = visible ? moveDirectionWhenHiding == "left" ? -width : width : 0;
			var xTo:Number = visible ? 0 : moveDirectionWhenHiding == "left" ? -width : width;
			x = xFrom;
			if (xFrom != xTo) {
				alpha = 1;
				isAnimating = true;
				TweenLite.to(this, ANIMATION_DURATION, {x: xTo, onComplete: animationComplete});
			}
		}
	}

	private function animationComplete():void {
		isAnimating = false;
		alpha = visible ? 1 : 0;
		if (hasPendingAnimation) {
			hasPendingAnimation = false;
			startMoveAnimation();
		}
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		if (w > 0 && !isAnimating)
			x = visible ? 0 : moveDirectionWhenHiding == "left" ? -w : w;
	}
}
}
