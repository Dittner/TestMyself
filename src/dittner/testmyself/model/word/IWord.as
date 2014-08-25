package dittner.testmyself.model.word {
import dittner.testmyself.model.common.ITransUnit;

public interface IWord extends ITransUnit {
	function get article():String;
	function get options():String;
}
}
