package de.dittner.testmyself.model.domain.word {
import de.dittner.testmyself.model.domain.note.INote;

public interface IWord extends INote {
	function get article():String;
	function get options():String;
}
}
