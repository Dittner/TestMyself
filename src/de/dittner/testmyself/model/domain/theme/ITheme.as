package de.dittner.testmyself.model.domain.theme {
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

public interface ITheme {
	function get id():int;
	function get name():String;
	function get vocabulary():Vocabulary
}
}
