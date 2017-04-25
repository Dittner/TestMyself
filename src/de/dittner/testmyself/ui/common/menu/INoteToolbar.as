package de.dittner.testmyself.ui.common.menu {
import mx.core.IUIComponent;

public interface INoteToolbar extends IUIComponent {
	function show():void;
	function hide():void;
	function revert():void;

	function enableGoBack(value:Boolean = true):void;
	function enableAddNote(value:Boolean = true):void;
	function enableEditNote(value:Boolean = true):void;
	function enableRemoveNote(value:Boolean = true):void;
	function enableShowDetails(value:Boolean = true):void;
	function enableTransInvert(value:Boolean = true):void;
	function enableFilter(value:Boolean = true):void;
	function enableShowFailedTasks(value:Boolean = true):void;
	function enablesSetTaskAsRight(value:Boolean = true):void;
	function enablePlayCommentBtn(value:Boolean = true):void;

	function selectTransInvert(value:Boolean = true):void;
	function selectShowDetails(value:Boolean = true):void;
	function selectShowFailedTasks(value:Boolean = true):void;
}
}