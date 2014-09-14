package dittner.testmyself.deutsch.model.domain.verb {
import dittner.testmyself.core.model.note.INote;

public interface IVerb extends INote {
	function get present():String;
	function get past():String;
	function get perfect():String;
}
}
