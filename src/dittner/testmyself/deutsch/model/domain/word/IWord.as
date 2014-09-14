package dittner.testmyself.deutsch.model.domain.word {
import dittner.testmyself.core.model.note.INote;

public interface IWord extends INote {
	function get article():String;
	function get options():String;
}
}
