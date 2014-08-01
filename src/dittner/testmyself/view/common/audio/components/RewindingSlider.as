package dittner.testmyself.view.common.audio.components {
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import spark.components.HSlider;

public class RewindingSlider extends HSlider {
	public function RewindingSlider() {
		super();
	}

	override protected function system_mouseMoveHandler(event:MouseEvent):void {
		super.system_mouseMoveHandler(event);
		dispatchEvent(new Event(Event.CHANGE));
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		dispatchEvent(new Event(Event.CHANGE));
	}

	override protected function updateSkinDisplayList():void {
		if (!thumb || !track)
			return;

		var thumbRange:Number = track.getLayoutBoundsWidth() - thumb.getLayoutBoundsWidth();
		var range:Number = maximum - minimum;

		// calculate new thumb position.
		var thumbPosTrackX:Number = (range > 0) ? ((pendingValue - minimum) / range) * thumbRange : 0;

		// convert to parent's coordinates.
		var thumbPos:Point = track.localToGlobal(new Point(thumbPosTrackX, 0));
		var thumbPosParentX:Number = thumb.parent.globalToLocal(thumbPos).x + 3 * (-1 + 2 * value / maximum);

		thumb.setLayoutBoundsPosition(Math.round(thumbPosParentX), thumb.getLayoutBoundsY());
	}

}
}
