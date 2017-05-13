package de.dittner.testmyself.ui.common.menu.pageSlider {
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.ui.common.audio.components.RewindingSlider;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;

import spark.components.Button;
import spark.skins.mobile.supportClasses.MobileSkin;

public class PageSliderSkin extends MobileSkin {

	public function PageSliderSkin() {
		super();
		thumbSkinClass = PageSliderThumbSkin;
		trackSkinClass = PageSliderTrackSkin;
	}

	public var hostComponent:RewindingSlider;

	//--------------------------------------------------------------------------
	//
	//  Skin parts
	//
	//--------------------------------------------------------------------------

	public var track:Button;
	public var thumb:Button;

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	protected var thumbSkinClass:Class;
	protected var trackSkinClass:Class;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	override protected function commitCurrentState():void {
		if (currentState == "disabled") {
			alpha = 0.5;
		}
		else if (currentState == "normal") {
			alpha = 1;
		}
	}

	override protected function createChildren():void {
		// Create our skin parts: track and thumb
		track = new Button();
		track.setStyle("skinClass", trackSkinClass);
		addChild(track);

		thumb = new Button();
		thumb.setStyle("skinClass", thumbSkinClass);
		addChild(thumb);
	}

	override protected function measure():void {
		measuredWidth = track.getPreferredBoundsWidth();
		measuredHeight = Math.max(track.getPreferredBoundsHeight(), thumb.getPreferredBoundsHeight());

		measuredMinHeight = Math.max(track.getPreferredBoundsHeight(), thumb.getPreferredBoundsHeight());
		measuredMinWidth = thumb.getPreferredBoundsWidth();
	}

	override protected function layoutContents(w:Number, h:Number):void {
		super.layoutContents(w, h);

		// minimum height is no smaller than the larger of the thumb or track
		var calculatedSkinHeight:int = Math.max(Math.max(thumb.getPreferredBoundsHeight(), track.getPreferredBoundsHeight()), h);

		// minimum width is no smaller than the thumb
		var calculatedSkinWidth:int = Math.max(thumb.getPreferredBoundsWidth(), w);

		// once we know the skin height, center the thumb and track
		thumb.y = 0;
		var calculatedTrackY:int = Math.max(Math.round((calculatedSkinHeight - track.getPreferredBoundsHeight()) / 2), 0);

		// size and position
		setElementSize(thumb, thumb.getPreferredBoundsWidth(), thumb.getPreferredBoundsHeight()); // thumb does NOT scale
		//
		setElementSize(track, calculatedSkinWidth, track.getPreferredBoundsHeight()); // note track is NOT scaled vertically
		setElementPosition(track, 0, calculatedTrackY);

		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(1, 0xffFFff);
		var totalLines:int = hostComponent.maximum - hostComponent.minimum;
		if (totalLines > 100) totalLines = totalLines / 10;
		var offset:Number = 7.5 * Device.factor;
		var step:Number = (w - 2 * offset) / totalLines;

		for (var i:Number = 0; i <= totalLines; i += hostComponent.stepSize) {
			g.moveTo(i * step + offset, Values.PT5);
			g.lineTo(i * step + offset, Values.PT20);
		}
	}
}
}