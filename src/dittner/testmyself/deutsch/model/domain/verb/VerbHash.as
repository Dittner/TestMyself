package dittner.testmyself.deutsch.model.domain.verb {
import dittner.testmyself.core.model.note.*;

public class VerbHash extends NoteHash {
	public function VerbHash() {}

	override public function getKey(note:INote):String {
		var verb:IVerb = note as IVerb;
		return verb.title + verb.present + verb.past + verb.perfect;
	}
}
}
