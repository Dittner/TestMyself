package de.dittner.testmyself.model.domain.note {
import de.dittner.satelliteFlight.proxy.SFProxy;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.page.INotePageInfo;

public class NoteModel extends SFProxy implements INoteModel {

	public function NoteModel():void {
		super();
	}

	//--------------------------------------
	//  pageInfo
	//--------------------------------------
	private var _pageInfo:INotePageInfo = null;
	public function get pageInfo():INotePageInfo {return _pageInfo;}
	public function set pageInfo(value:INotePageInfo):void {
		_pageInfo = value;
		sendNotification(NoteMsg.NOTE_PAGE_INFO_CHANGED_NOTIFICATION, pageInfo);
	}

	//--------------------------------------
	//  themes
	//--------------------------------------
	private var _themes:Array;
	public function get themes():Array {return _themes;}
	public function set themes(value:Array):void {
		if (_themes != value) {
			_themes = value;
			sendNotification(NoteMsg.THEMES_CHANGED_NOTIFICATION, themes);
		}
	}

	//--------------------------------------
	//  dataBaseInfo
	//--------------------------------------
	private var _dataBaseInfo:NotesInfo;
	public function get dataBaseInfo():NotesInfo {return _dataBaseInfo;}
	public function set dataBaseInfo(value:NotesInfo):void {
		if (_dataBaseInfo != value) {
			_dataBaseInfo = value;
			sendNotification(NoteMsg.NOTES_INFO_CHANGED_NOTIFICATION, dataBaseInfo);
		}
	}

	//--------------------------------------
	//  selectedNote
	//--------------------------------------
	public function get selectedNote():INote {return pageInfo ? pageInfo.selectedNote : null;}
	public function set selectedNote(value:INote):void {
		if (pageInfo && pageInfo.selectedNote != value) {
			pageInfo.selectedNote = value;
			sendNotification(NoteMsg.NOTE_SELECTED_NOTIFICATION, selectedNote);
		}
	}

	//--------------------------------------
	//  filter
	//--------------------------------------
	private var _filter:NoteFilter = new NoteFilter();
	public function get filter():NoteFilter {return _filter;}
	public function set filter(value:NoteFilter):void {
		_filter = value;
	}

	//--------------------------------------
	//  noteHash
	//--------------------------------------
	private var _noteHash:NoteHash = new NoteHash();
	public function get noteHash():NoteHash {return _noteHash;}
	public function set noteHash(value:NoteHash):void {
		_noteHash = value;
	}

}
}
