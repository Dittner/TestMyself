package de.dittner.testmyself.model.domain.verb {
import de.dittner.testmyself.model.domain.note.INote;

public interface IVerb extends INote {
	function get present():String;
	function get past():String;
	function get perfect():String;
}
}
