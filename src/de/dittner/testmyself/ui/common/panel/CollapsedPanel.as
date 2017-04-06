package de.dittner.testmyself.ui.common.panel {
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.utils.Values;

import flash.events.Event;

import spark.components.SkinnableContainer;

public class CollapsedPanel extends SkinnableContainer {
	public function CollapsedPanel() {
		super();
		setStyle("skinClass", CollapsedPanelSkin);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	[SkinPart(required="true")]
	public var headerBtn:FadeTileButton;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//  title
	//--------------------------------------------------------------------------
	private var _title:String;
	[Bindable("titleChanged")]
	public function get title():String {return _title;}
	public function set title(value:String):void {
		if (_isOpened != value) {
			_title = value;
			invalidateProperties();
			invalidateDisplayList();
			dispatchEvent(new Event("titleChanged"));
		}
	}

	//--------------------------------------
	//  isOpen
	//--------------------------------------
	private var _isOpened:Boolean = false;
	[Bindable("isOpenedChanged")]
	public function get isOpened():Boolean {return _isOpened;}
	public function set isOpened(value:Boolean):void {
		if (_isOpened != value) {
			_isOpened = value;
			if (skin) {
				skin.invalidateSize();
				skin.invalidateDisplayList();
			}
			if (headerBtn)
				headerBtn.selected = isOpened;
			dispatchEvent(new Event("isOpenedChanged"));
		}
	}

	//--------------------------------------
	//  paddingLeft
	//--------------------------------------
	private var _paddingLeft:Number = Values.PT20;
	[Bindable("paddingLeftChanged")]
	public function get paddingLeft():Number {return _paddingLeft;}
	public function set paddingLeft(value:Number):void {
		if (_paddingLeft != value) {
			_paddingLeft = value;
			if (skin) {
				skin.invalidateSize();
				skin.invalidateDisplayList();
			}
			dispatchEvent(new Event("paddingLeftChanged"));
		}
	}

	//--------------------------------------
	//  paddingRight
	//--------------------------------------
	private var _paddingRight:Number = Values.PT20;
	[Bindable("paddingRightChanged")]
	public function get paddingRight():Number {return _paddingRight;}
	public function set paddingRight(value:Number):void {
		if (_paddingRight != value) {
			_paddingRight = value;
			if (skin) {
				skin.invalidateSize();
				skin.invalidateDisplayList();
			}
			dispatchEvent(new Event("paddingRightChanged"));
		}
	}

	//--------------------------------------
	//  paddingTop
	//--------------------------------------
	private var _paddingTop:Number = Values.PT20;
	[Bindable("paddingTopChanged")]
	public function get paddingTop():Number {return _paddingTop;}
	public function set paddingTop(value:Number):void {
		if (_paddingTop != value) {
			_paddingTop = value;
			if (skin) {
				skin.invalidateSize();
				skin.invalidateDisplayList();
			}
			dispatchEvent(new Event("paddingTopChanged"));
		}
	}

	//--------------------------------------
	//  paddingBottom
	//--------------------------------------
	private var _paddingBottom:Number = Values.PT20;
	[Bindable("paddingBottomChanged")]
	public function get paddingBottom():Number {return _paddingBottom;}
	public function set paddingBottom(value:Number):void {
		if (_paddingBottom != value) {
			_paddingBottom = value;
			if (skin) {
				skin.invalidateSize();
				skin.invalidateDisplayList();
			}
			dispatchEvent(new Event("paddingBottomChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);
		if (instance == headerBtn) {
			headerBtn.selected = isOpened;
			headerBtn.addEventListener(Event.CHANGE, headerBtnChangeHandler);
		}
	}

	override protected function partRemoved(partName:String, instance:Object):void {
		super.partAdded(partName, instance);
		if (instance == headerBtn) {
			headerBtn.removeEventListener(Event.CHANGE, headerBtnChangeHandler);
		}
	}

	override protected function commitProperties():void {
		super.commitProperties();
		headerBtn.title = title;
	}

	private function headerBtnChangeHandler(event:Event):void {
		isOpened = headerBtn.selected;
	}

}
}