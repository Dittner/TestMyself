package dittner.testmyself.deutsch.model.phrase {
import dittner.satelliteFlight.message.RequestMessage;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.demo.*;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.model.theme.Theme;

public class PhraseDemoData extends SFProxy implements IDemoData {
	public function PhraseDemoData() {}

	public function add():void {
		createAndSendNotes();
	}

	private function createAndSendNotes():void {
		var phrase:Note;

		phrase = new Note();
		phrase.title = "Die Wahrheit bedarf nicht viele Worte, die Luge kann nie genug haben.";
		phrase.description = "Истина не многословна, для лжи слов всегда недостаточно.";
		sendAddNoteRequest(phrase, createTheme("Zitate", -1));

		phrase = new Note();
		phrase.title = "Wer fremde Sprache nicht kennt, weiß nichts von seiner eigenen. Goethe.";
		phrase.description = "Тот, кому чужды иностранные языки – ничего не смыслит в собственном языке.";
		sendAddNoteRequest(phrase, createTheme("Zitate", 1));

		phrase = new Note();
		phrase.title = "Wir kommen nie zu Gedanken. Sie kommen zu uns. Heidegger.";
		phrase.description = "Мы никогда не приходим к мыслям. Они приходят к нам.";
		sendAddNoteRequest(phrase, createTheme("Zitate", 1));

		phrase = new Note();
		phrase.title = "Was mich nicht umbringt, macht mich stärker. Nietzsche.";
		phrase.description = "Что меня не убивает - делает меня сильнее.";
		sendAddNoteRequest(phrase, createTheme("Zitate", 1));

		phrase = new Note();
		phrase.title = "Wer Schmetterlinge lachen hört, der weiß, wie Wolken schmecken.";
		phrase.description = "Кто слышит, как смеются бабочки, тот знает, как приятны на вкус облака.";
		sendAddNoteRequest(phrase, createTheme("Zitate", 1));

		phrase = new Note();
		phrase.title = "Wer kein Spass am Leben findet, verliert die Freude am Dasein.";
		phrase.description = "Кто не находит удовольствия в жизни, тот радость бытия теряет.";
		sendAddNoteRequest(phrase, createTheme("Zitate", 1));

		phrase = new Note();
		phrase.title = "Ich weiß, es wird einmal ein Wunder geschehen. Zarah Leander.";
		phrase.description = "Я знаю, что однажды произойдет чудо.";
		sendAddNoteRequest(phrase, createTheme("Zitate", 1));
	}

	private function createTheme(name:String, id:int):Theme {
		var res:Theme = new Theme();
		res.name = name;
		res.id = id;
		return res;
	}

	private function sendAddNoteRequest(note:Note, theme:Theme):void {
		var suite:NoteSuite = new NoteSuite();
		suite.note = note;
		suite.themes = [theme];
		suite.examples = [];
		sendRequest(NoteMsg.ADD_NOTE, new RequestMessage(null, null, suite));
	}
}
}
