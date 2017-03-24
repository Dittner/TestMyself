package de.dittner.testmyself.ui.view.main {
import de.dittner.testmyself.ui.common.menu.MenuBoard;
import de.dittner.testmyself.ui.view.noteList.components.form.NoteForm;
import de.dittner.testmyself.ui.view.noteList.components.toolbar.NoteToolbar;

public interface IMainView {
	function get menu():MenuBoard;
	function get toolbar():NoteToolbar;
	function get form():NoteForm;
}
}
