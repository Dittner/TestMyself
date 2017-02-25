package de.dittner.testmyself.ui.common.menu {
import mx.core.IUIComponent;

public interface IMenuBoard extends IUIComponent {
	function showViewMenu():void;
	function showFormMenu():void;
	function showTestMenu(trueBtnEnabled:Boolean = true, falseBtnEnabled:Boolean = true, nextTaskBtnEnabled:Boolean = false):void;
	function showPrevMenu():void;

	function get taskPriority():uint;
	function set taskPriority(value:uint):void;
}
}
