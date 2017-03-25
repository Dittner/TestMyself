package de.dittner.testmyself.ui.common.audio.skins.slider {
import de.dittner.testmyself.ui.common.audio.components.RewindingSlider;

import flash.events.Event;

import mx.core.ClassFactory;
import mx.core.IFactory;

import spark.components.Button;
import spark.skins.mobile.supportClasses.HSliderDataTip;
import spark.skins.mobile.supportClasses.MobileSkin;

public class RewindingSliderSkin extends MobileSkin {

	public function RewindingSliderSkin() {
		super();

		thumbSkinClass = RewindingSliderThumbSkin;
		trackSkinClass = RewindingSliderTrackSkin;
		barSkinClass = RewindingSliderBarSkin;
		dataTipClass = HSliderDataTip;

	}

	public var hostComponent:RewindingSlider;

	//--------------------------------------------------------------------------
	//
	//  Skin parts
	//
	//--------------------------------------------------------------------------

	public var track:Button;
	private var bar:Button;
	public var thumb:Button;
	public var dataTip:IFactory;

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	protected var thumbSkinClass:Class;
	protected var barSkinClass:Class;
	protected var trackSkinClass:Class;
	protected var dataTipClass:Class;

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

		bar = new Button();
		bar.setStyle("skinClass", barSkinClass);
		addChild(bar);

		hostComponent.addEventListener(Event.CHANGE, updateBarOnChange);

		thumb = new Button();
		thumb.setStyle("skinClass", thumbSkinClass);
		addChild(thumb);
		thumb.addEventListener(Event.CHANGE, updateBarOnChange);
		// Set up the class factory for the dataTip
		dataTip = new ClassFactory();
		ClassFactory(dataTip).generator = dataTipClass;
	}

	private function updateBarOnChange(event:Event = null):void {
		var calculatedBarWidth:int = thumb.x + thumb.getPreferredBoundsWidth() / 2;
		setElementSize(bar, calculatedBarWidth, bar.getPreferredBoundsHeight());
		var calculatedSkinHeight:int = Math.max(Math.max(thumb.getPreferredBoundsHeight(), track.getPreferredBoundsHeight()), unscaledHeight);

		// minimum width is no smaller than the thumb
		var calculatedSkinWidth:int = Math.max(thumb.getPreferredBoundsWidth(), unscaledWidth);

		var calculatedTrackY:int = Math.max(Math.round((calculatedSkinHeight - track.getPreferredBoundsHeight()) / 2), 0);

		setElementPosition(bar, 1, calculatedTrackY - 1);
	}

	override protected function measure():void {
		measuredWidth = track.getPreferredBoundsWidth();
		measuredHeight = Math.max(track.getPreferredBoundsHeight(), thumb.getPreferredBoundsHeight());

		measuredMinHeight = Math.max(track.getPreferredBoundsHeight(), thumb.getPreferredBoundsHeight());
		measuredMinWidth = thumb.getPreferredBoundsWidth();
	}

	override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void {
		super.layoutContents(unscaledWidth, unscaledHeight);

		// minimum height is no smaller than the larger of the thumb or track
		var calculatedSkinHeight:int = Math.max(Math.max(thumb.getPreferredBoundsHeight(), track.getPreferredBoundsHeight()), unscaledHeight);

		// minimum width is no smaller than the thumb
		var calculatedSkinWidth:int = Math.max(thumb.getPreferredBoundsWidth(), unscaledWidth);

		// once we know the skin height, center the thumb and track
		thumb.y = 0;
		var calculatedTrackY:int = Math.max(Math.round((calculatedSkinHeight - track.getPreferredBoundsHeight()) / 2), 0);

		// size and position
		setElementSize(thumb, thumb.getPreferredBoundsWidth(), thumb.getPreferredBoundsHeight()); // thumb does NOT scale
		//
		setElementSize(track, calculatedSkinWidth, track.getPreferredBoundsHeight()); // note track is NOT scaled vertically
		setElementPosition(track, 0, calculatedTrackY);
		updateBarOnChange();

	}
}
}