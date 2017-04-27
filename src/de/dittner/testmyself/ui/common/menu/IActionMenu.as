package de.dittner.testmyself.ui.common.menu {
import de.dittner.testmyself.ui.common.page.NotePage;

import mx.core.IUIComponent;

public interface IActionMenu extends IUIComponent {
	function showFormMenu(formMode:String):void;
	function showNavigationMenu(page:NotePage):void;
	function showPaginationBar(page:NotePage):void;
	function showTestMenu(trueBtnEnabled:Boolean = true, falseBtnEnabled:Boolean = true, nextTaskBtnEnabled:Boolean = false):void;
	function hide():void;

	function get taskPriority():uint;
	function set taskPriority(value:uint):void;
}
}
