package de.dittner.testmyself.ui.view.noteList.components.form.articleList {

import de.dittner.testmyself.ui.common.tile.FadeTileButton;

import flash.events.MouseEvent;
import flash.text.TextField;

import mx.events.FlexEvent;

import spark.components.List;
import spark.events.IndexChangeEvent;

public class ListBox extends List {
	public function ListBox() {
		super();
		addEventListener(IndexChangeEvent.CHANGE, indexChangeHandler);
		addEventListener(FlexEvent.VALUE_COMMIT, valueCommitHandler);
	}

	[SkinPart(required="true")]
	public var dropDownBtn:FadeTileButton;

	[SkinPart(required="true")]
	public var dropDownTf:TextField;

	//--------------------------------------------------------------------------
	//  partAdded
	//--------------------------------------------------------------------------
	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);
		if (instance == dropDownBtn) {
			dropDownBtn.addEventListener(MouseEvent.CLICK, dropDownBtnClickHandler);
		}
		else if (instance == dropDownTf) {
			if (selectedItem && selectedItem is String) dropDownTf.text = selectedItem as String;
		}
		else if (instance == scroller) {
			scroller.visible = scroller.includeInLayout = false;
		}
	}

	//--------------------------------------------------------------------
	//  partRemoved
	//--------------------------------------------------------------------
	override protected function partRemoved(partName:String, instance:Object):void {
		super.partRemoved(partName, instance);
		if (instance == dropDownBtn) {
			dropDownBtn.removeEventListener(MouseEvent.CLICK, dropDownBtnClickHandler);
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Handlers
	//
	//--------------------------------------------------------------------------

	protected function dropDownBtnClickHandler(event:MouseEvent):void {
		scroller.visible = scroller.includeInLayout = !scroller.visible;
	}

	protected function indexChangeHandler(event:IndexChangeEvent):void {
		if (selectedItem && selectedItem is String) dropDownTf.text = selectedItem as String;
		scroller.visible = scroller.includeInLayout = false;
	}

	protected function valueCommitHandler(event:FlexEvent):void {
		dropDownTf.text = selectedItem is String ? selectedItem as String : "";
	}
}
}