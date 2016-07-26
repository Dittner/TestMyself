package de.dittner.testmyself.model.domain.note {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.view.noteList.components.form.NoteValidationErrorKey;

import flash.events.Event;
import flash.events.EventDispatcher;

public class Note extends EventDispatcher implements INote {
	public function Note() {
		super();
	}

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
	public function get vocabulary():Vocabulary {return _vocabulary;}
	public function set vocabulary(value:Vocabulary):void {_vocabulary = value;}

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
	private var _themes:Vector.<Theme> = new <Theme>[];
	[Bindable("themeIDsChanged")]
	public function get themes():Vector.<Theme> {return _themes;}
	public function set themes(value:Vector.<Theme>):void {
		if (_themes != value) {
			_themes = value || new <Theme>[];
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
	//  examples
	//--------------------------------------
	private var _examples:Array;
	[Bindable("examplesChanged")]
	public function get examples():Array {return _examples;}
	public function set examples(value:Array):void {
		if (_examples != value) {
			_examples = value;
			dispatchEvent(new Event("examplesChanged"));
		}
	}

	//--------------------------------------
	//  options
	//--------------------------------------
	private var _options:Object = {};
	[Bindable("optionsChanged")]
	public function get options():Object {return _options;}
	public function set options(value:Object):void {
		if (_options != value) {
			_options = value;
			dispatchEvent(new Event("optionsChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function createExample():Note {
		var res:Note = new Note();
		res.isExample = true;
		res.vocabulary = vocabulary;
		res.parentID = id;
		return res;
	}

	public function store():IAsyncOperation {
		return vocabulary.storage.storeNote(this);
	}

	public function remove():IAsyncOperation {
		return vocabulary.storage.removeNote(this);
	}

	public function serialize():Object {
		var res:Object = {};
		res.vocabularyID = vocabulary.id;
		res.parentID = parentID;
		res.title = title;
		res.description = description;
		res.isExample = isExample;
		res.options = options;
		res.searchText = title + description;
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
		_options = data.options;
		_audioComment = data.audioComment;
	}

	public function validate():String {
		if (!title) {
			return NoteValidationErrorKey.EMPTY_NOTE_TITLE;
		}
		else if (!description) {
			return NoteValidationErrorKey.EMPTY_NOTE_DESCRIPTION;
		}
		else if (!isExample) {
			for each(var e:Note in examples)
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
			examples = reloadedNote.examples;
		}
	}

}
}
