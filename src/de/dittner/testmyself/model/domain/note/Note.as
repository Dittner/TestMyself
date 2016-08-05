package de.dittner.testmyself.model.domain.note {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.view.noteList.components.form.NoteValidationErrorKey;

import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;

public class Note extends EventDispatcher {
	public function Note() {
		super();
	}

	protected var options:Object = {};

	//--------------------------------------
	//  id
	//--------------------------------------
	private var _id:int = -1;
	public function get id():int {return _id;}
	public function set id(value:int):void {_id = value;}

	//--------------------------------------
	//  vocabulary
	//--------------------------------------
	private var _vocabulary:Vocabulary;
	[Bindable("vocabularyChanged")]
	public function get vocabulary():Vocabulary {return _vocabulary;}
	public function set vocabulary(value:Vocabulary):void {
		if (_vocabulary != value) {
			_vocabulary = value;
			dispatchEvent(new Event("vocabularyChanged"));
		}
	}

	//--------------------------------------
	//  parentID
	//--------------------------------------
	private var _parentID:int = -1;
	public function get parentID():int {return _parentID;}
	public function set parentID(value:int):void {_parentID = value;}

	//--------------------------------------
	//  isNew
	//--------------------------------------
	public function get isNew():Boolean {return _id == -1;}

	//--------------------------------------
	//  title
	//--------------------------------------
	private var _title:String = "";
	[Bindable("titleChanged")]
	public function get title():String {return _title;}
	public function set title(value:String):void {
		if (_title != value) {
			_title = value || "";
			dispatchEvent(new Event("titleChanged"));
		}
	}

	//--------------------------------------
	//  description
	//--------------------------------------
	private var _description:String = "";
	[Bindable("descriptionChanged")]
	public function get description():String {return _description;}
	public function set description(value:String):void {
		if (_description != value) {
			_description = value || "";
			dispatchEvent(new Event("descriptionChanged"));
		}
	}

	//--------------------------------------
	//  audioComment
	//--------------------------------------
	private var _audioComment:AudioComment = new AudioComment();
	[Bindable("audioCommentChanged")]
	public function get hasAudioComment():Boolean {return _audioComment && _audioComment.bytes;}
	public function get audioComment():AudioComment {return _audioComment;}
	public function set audioComment(value:AudioComment):void {
		if (_audioComment != value) {
			_audioComment = value || new AudioComment();
			dispatchEvent(new Event("audioCommentChanged"));
		}
	}

	//--------------------------------------
	//  themes
	//--------------------------------------
	private var _themes:Array = [];
	[Bindable("themeIDsChanged")]
	public function get themes():Array {return _themes;}
	public function set themes(value:Array):void {
		if (_themes != value) {
			_themes = value || [];
			dispatchEvent(new Event("themesChanged"));
		}
	}

	//--------------------------------------
	//  isExample
	//--------------------------------------
	private var _isExample:Boolean = false;
	[Bindable("isExampleChanged")]
	public function get isExample():Boolean {return _isExample;}
	public function set isExample(value:Boolean):void {
		if (_isExample != value) {
			_isExample = value;
			dispatchEvent(new Event("isExampleChanged"));
		}
	}

	//--------------------------------------
	//  exampleColl
	//--------------------------------------
	private var _exampleColl:ArrayCollection = new ArrayCollection();
	[Bindable("exampleCollChanged")]
	public function get exampleColl():ArrayCollection {return _exampleColl;}
	public function set exampleColl(value:ArrayCollection):void {
		if (_exampleColl != value) {
			_exampleColl = value;
			dispatchEvent(new Event("exampleCollChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function createExample():Note {
		return Note.createExample(vocabulary, id);
	}

	public static function createExample(vocabulary:Vocabulary, parentID:int):Note {
		var res:Note = new Note();
		res.isExample = true;
		res.vocabulary = vocabulary;
		res.parentID = parentID;
		return res;
	}

	public function store():IAsyncOperation {
		var op:IAsyncOperation = vocabulary.storage.storeNote(this);
		op.addCompleteCallback(noteStored);
		return op;
	}

	private function noteStored(op:IAsyncOperation):void {
		if (!isExample && originalData.title && originalData.title != title)
			vocabulary.noteTitleHash.clear(originalData.title);
		originalData.title = title;
		vocabulary.noteTitleHash.write(title, true);
	}

	public function remove():IAsyncOperation {
		var op:IAsyncOperation = vocabulary.storage.removeNote(this);
		op.addCompleteCallback(noteRemoved);
		return op;
	}

	private function noteRemoved(op:IAsyncOperation):void {
		if (!isExample) vocabulary.noteTitleHash.clear(title);
	}

	public function serialize():Object {
		var res:Object = {};
		res.vocabularyID = vocabulary.id;
		res.parentID = parentID;
		res.title = title;
		res.description = description;
		res.isExample = isExample;
		res.options = options;
		res.searchText = title + "+" + description;
		res.searchText = res.searchText.toLowerCase();
		res.audioComment = audioComment.bytes ? audioComment : null;
		return res;
	}

	private var _originalData:Object = {};
	public function get originalData():Object {return _originalData;}

	public function deserialize(data:Object):void {
		_originalData = data;
		_id = data.id;
		_parentID = data.parentID;
		_title = data.title;
		_description = data.description;
		_isExample = data.isExample;
		_audioComment = data.audioComment || new AudioComment();
		options = data.options;
	}

	public function validate():String {
		if (!title) {
			return NoteValidationErrorKey.EMPTY_NOTE_TITLE;
		}
		else if (!description) {
			return NoteValidationErrorKey.EMPTY_NOTE_DESCRIPTION;
		}
		else if (!isExample) {
			for each(var e:Note in exampleColl)
				if (!e.title) return NoteValidationErrorKey.EMPTY_EXAMPLE_TITLE;
				else if (!e.description) return NoteValidationErrorKey.EMPTY_EXAMPLE_DESCRIPTION;
		}
		return "";
	}

	public function revertChanges():IAsyncOperation {
		var op:IAsyncOperation;
		if (isNew) {
			op = new AsyncOperation();
			op.dispatchSuccess();
		}
		else {
			op = vocabulary.storage.loadNote(vocabulary, id);
			op.addCompleteCallback(noteReloaded)
		}
		return op;
	}

	private function noteReloaded(op:IAsyncOperation):void {
		if (op.isSuccess) {
			var reloadedNote:Note = op.result;
			deserialize(reloadedNote.originalData);
			themes = reloadedNote.themes;
			exampleColl = reloadedNote.exampleColl;
		}
	}

}
}
