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
		const notesAmount:uint = 30;
		var themeNum:int;

		sendAddNoteRequest(createNote(1, 1001), createTheme("theme1", -1));
		sendAddNoteRequest(createNote(2, 1002), createTheme("theme2", -1));
		sendAddNoteRequest(createNote(3, 1003), createTheme("theme3", -1));

		for (var i:int = 1; i <= notesAmount; i++) {
			if (i > 2 / 3 * notesAmount) themeNum = 3;
			else if (i > notesAmount / 3) themeNum = 2;
			else themeNum = 1;
			sendAddNoteRequest(createNote(themeNum, i), createTheme("theme" + themeNum, themeNum));
		}
	}

	private function createNote(themeNum:int, number:int):Note {
		var note:Note = new Note();
		note.title = "theme" + themeNum + ", text" + number;
		note.description = "translation";
		return note;
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
		sendRequest(NoteMsg.ADD_NOTE, new RequestMessage(null, null, suite));
	}
}
}
