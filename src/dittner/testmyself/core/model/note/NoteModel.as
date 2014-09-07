package dittner.testmyself.core.model.note {
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.page.IPageInfo;

public class NoteModel extends SFProxy implements INoteModel {

	public function NoteModel():void {
		super();
	}

	//--------------------------------------
	//  pageInfo
	//--------------------------------------
	private var _pageInfo:IPageInfo = null;
	public function get pageInfo():IPageInfo {return _pageInfo;}
	public function set pageInfo(value:IPageInfo):void {
		_pageInfo = value;
		sendNotification(NoteMsg.PAGE_INFO_CHANGED_NOTIFICATION, pageInfo);
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
	private var _filter:Array = [];
	public function get filter():Array {return _filter;}
	public function set filter(value:Array):void {
		if (_filter != value) {
			_filter = value;
		}
	}

}
}
