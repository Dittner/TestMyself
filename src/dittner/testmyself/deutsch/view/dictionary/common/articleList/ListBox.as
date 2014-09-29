package dittner.testmyself.deutsch.view.dictionary.common.articleList {

import flash.events.MouseEvent;

import mx.events.FlexEvent;

import spark.components.Button;
import spark.components.List;
import spark.events.IndexChangeEvent;

public class ListBox extends List {
	public function ListBox() {
		super();
		addEventListener(IndexChangeEvent.CHANGE, indexChangeHandler);
		addEventListener(FlexEvent.VALUE_COMMIT, valueCommitHandler);
	}

	[SkinPart(required="true")]
	public var dropDownBtn:Button;

	//--------------------------------------------------------------------------
	//  partAdded
	//--------------------------------------------------------------------------
	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);
		if (instance == dropDownBtn) {
			dropDownBtn.addEventListener(MouseEvent.CLICK, dropDownBtnClickHandler);
			if (selectedItem && selectedItem is String) dropDownBtn.label = selectedItem as String;
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
		if (selectedItem && selectedItem is String) dropDownBtn.label = selectedItem as String;
		scroller.visible = scroller.includeInLayout = false;
	}

	protected function valueCommitHandler(event:FlexEvent):void {
		dropDownBtn.label = selectedItem is String ? selectedItem as String : "";
	}
}
}