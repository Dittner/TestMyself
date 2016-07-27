package de.dittner.testmyself.model.domain.test {
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.word.DeWord;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

public class SelectArticleTest extends Test {
	public function SelectArticleTest(vocabulary:Vocabulary, title:String) {
		super(TestID.SELECT_ARTICLE, vocabulary, title);
	}

	override public function isValidForTest(note:Note):Boolean {
		return note is DeWord && (note as DeWord).article;
	}

}
}
