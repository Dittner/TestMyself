package de.dittner.testmyself.ui.view.main {
import de.dittner.testmyself.ui.common.menu.ActionMenu;
import de.dittner.testmyself.ui.common.menu.NavigationMenu;
import de.dittner.testmyself.ui.common.menu.NoteToolbar;
import de.dittner.testmyself.ui.view.noteList.components.form.NoteForm;

public interface IMainView {
	function get navigationMenu():NavigationMenu;
	function get actionMenu():ActionMenu;
	function get toolbar():NoteToolbar;
	function get form():NoteForm;
}
}
