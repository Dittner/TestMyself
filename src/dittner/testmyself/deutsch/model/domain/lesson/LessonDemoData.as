package dittner.testmyself.deutsch.model.domain.lesson {
import dittner.satelliteFlight.message.RequestMessage;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.demo.*;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.model.theme.Theme;

public class LessonDemoData extends SFProxy implements IDemoData {
	public function LessonDemoData() {}

	public function add():void {
		createAndSendNotes();
	}

	private function createAndSendNotes():void {
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
