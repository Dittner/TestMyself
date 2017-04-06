package de.dittner.testmyself.ui.common.menu {
import mx.core.IUIComponent;

public interface IActionMenu extends IUIComponent {
	function showFormMenu():void;
	function showNavigationMenu():void;
	function showTestMenu(trueBtnEnabled:Boolean = true, falseBtnEnabled:Boolean = true, nextTaskBtnEnabled:Boolean = false):void;
	function showPrevMenu():void;
	function hide():void;

	function get taskPriority():uint;
	function set taskPriority(value:uint):void;
}
}
