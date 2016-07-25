package de.dittner.testmyself.model.domain.note {
import de.dittner.testmyself.model.domain.theme.Theme;

public class NoteFilter {

	public var selectedTheme:Theme;
	public var searchText:String = "";
	public var searchFullIdentity:Boolean = false;
}
}
