package dittner.testmyself.deutsch.model.word {
import dittner.testmyself.core.model.note.*;

public class WordHash extends NoteHash {
	public function WordHash() {}

	override public function getKey(note:INote):String {
		var word:IWord = note as IWord;
		return word.article + word.title;
	}
}
}
