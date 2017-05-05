package de.dittner.testmyself.ui.view.main {
import de.dittner.testmyself.ui.common.menu.IActionMenu;
import de.dittner.testmyself.ui.common.menu.INavigationMenu;
import de.dittner.testmyself.ui.common.menu.INoteToolbar;

import flash.events.IEventDispatcher;

public interface IMainView extends IEventDispatcher {
	function get navigationMenu():INavigationMenu;
	function get actionMenu():IActionMenu;
	function get toolbar():INoteToolbar;
	function get appBgColor():uint;
}
}
