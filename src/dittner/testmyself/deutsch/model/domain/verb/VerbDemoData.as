package dittner.testmyself.deutsch.model.domain.verb {
import dittner.satelliteFlight.message.RequestMessage;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.demo.*;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.model.theme.Theme;

public class VerbDemoData extends SFProxy implements IDemoData {
	public function VerbDemoData() {}

	public function add():void {
		createAndSendNotes();
	}

	private function createAndSendNotes():void {
		var verb:Verb;
		var examples:Array = [];

		/*ei-i*/

		verb = new Verb();
		verb.title = "beißen";
		verb.present = "beißt";
		verb.past = "biß";
		verb.perfect = "gebissen";
		verb.description = "кусать";
		sendAddNoteRequest(verb, createTheme("ei-i", -1), examples);

		verb = new Verb();
		verb.title = "gleichen";
		verb.present = "gleicht";
		verb.past = "glich";
		verb.perfect = "geglichen";
		verb.description = "походить, быть похожим";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "gleiten";
		verb.present = "gleitet";
		verb.past = "glitt";
		verb.perfect = "geglitten";
		verb.description = "скользить";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "greifen";
		verb.present = "greift";
		verb.past = "griff";
		verb.perfect = "gegriffen";
		verb.description = "хватать";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "leiden";
		verb.present = "leidet";
		verb.past = "litt";
		verb.perfect = "gelitten";
		verb.description = "страдать, терпеть";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "pfeifen";
		verb.present = "pfeift";
		verb.past = "pfiff";
		verb.perfect = "gepfiffen";
		verb.description = "свистеть";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "reißen";
		verb.present = "reißt";
		verb.past = "riß";
		verb.perfect = "gerissen";
		verb.description = "рвать";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "reiten";
		verb.present = "reitet";
		verb.past = "ritt";
		verb.perfect = "geritten";
		verb.description = "ездить верхом";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "schleichen";
		verb.present = "schleicht";
		verb.past = "schlich";
		verb.perfect = "geschlichen";
		verb.description = "красться";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "schleifen";
		verb.present = "schleift";
		verb.past = "schliff";
		verb.perfect = "geschliffen";
		verb.description = "шлифовать";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "schneiden";
		verb.present = "schneidet";
		verb.past = "schnitt";
		verb.perfect = "geschnitten";
		verb.description = "резать, разводиться, разделять";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "schreiten";
		verb.present = "schreitet";
		verb.past = "schritt";
		verb.perfect = "geschritten";
		verb.description = "шагать";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "streichen";
		verb.present = "streicht";
		verb.past = "strich";
		verb.perfect = "gestrichen";
		verb.description = "бродить, гладить";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "streiten";
		verb.present = "streitet";
		verb.past = "stritt";
		verb.perfect = "gestritten";
		verb.description = "ссориться, спорить";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

		verb = new Verb();
		verb.title = "weichen";
		verb.present = "weicht";
		verb.past = "wich";
		verb.perfect = "gewichen";
		verb.description = "уступать, отступать, смягчать";
		sendAddNoteRequest(verb, createTheme("ei-i", 1), examples);

	}

	private function createTheme(name:String, id:int):Theme {
		var res:Theme = new Theme();
		res.name = name;
		res.id = id;
		return res;
	}

	private function createExample(title:String, translate:String = ""):Note {
		var res:Note = new Note();
		res.title = title;
		res.description = translate;
		return res;
	}

	private function sendAddNoteRequest(note:Note, theme:Theme, examples:Array = null):void {
		var suite:NoteSuite = new NoteSuite();
		suite.note = note;
		suite.themes = theme ? [theme] : [];
		suite.examples = examples ? examples : [];
		sendRequest(NoteMsg.ADD_NOTE, new RequestMessage(null, null, suite));
	}
}
}
