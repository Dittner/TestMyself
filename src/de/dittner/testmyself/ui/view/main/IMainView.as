package de.dittner.testmyself.ui.view.main {
import de.dittner.testmyself.ui.common.menu.IActionMenu;
import de.dittner.testmyself.ui.common.menu.INavigationMenu;
import de.dittner.testmyself.ui.common.menu.INoteToolbar;
import de.dittner.testmyself.ui.view.settings.components.SettingsInfo;

public interface IMainView {
	function get navigationMenu():INavigationMenu;
	function get actionMenu():IActionMenu;
	function get toolbar():INoteToolbar;
	function get settings():SettingsInfo;
}
}
