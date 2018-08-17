package de.dittner.testmyself.model.domain.note {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.audio.mp3.MP3Player;
import de.dittner.testmyself.ui.view.form.components.NoteValidationErrorKey;

import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;

public class Note extends EventDispatcher {
	public static const SEARCH_DELIMITER:String = "+";
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
	public function get audioComment():AudioComment {return _audioComment;}
	public function set audioComment(value:AudioComment):void {
		if (_audioComment != value) {
			_audioComment = value || new AudioComment();
			setHasAudio(_audioComment.hasBytes);
			_audioComment.id = id;
			dispatchEvent(new Event("audioCommentChanged"));
		}
	}

	//--------------------------------------
	//  hasAudio
	//--------------------------------------
	private var _hasAudio:Boolean = false;
	[Bindable("hasAudioChanged")]
	public function get hasAudio():Boolean {return _hasAudio;}
	private function setHasAudio(value:Boolean):void {
		if (_hasAudio != value) {
			_hasAudio = value;
			dispatchEvent(new Event("hasAudioChanged"));
		}
	}

	//--------------------------------------
	//  tagIDs
	//--------------------------------------
	private var _tagIDs:Array = [];
	[Bindable("tagIDsChanged")]
	public function get tagIDs():Array {return _tagIDs;}
	public function set tagIDs(value:Array):void {
		if (_tagIDs != value) {
			_tagIDs = value;
			dispatchEvent(new Event("tagIDsChanged"));
		}
	}

	public function getTags():Array {
		var res:Array = [];
		if (tagIDs.length > 0) {
			for each(var tagID:int in tagIDs)
				if (vocabulary.tagHash[tagID])
					res.push(vocabulary.tagHash[tagID])
		}
		return res;
	}

	public function tagsToStr():String {
		var res:String = "";
		var tags:Array = getTags();
		for each(var tag:Tag in tags) {
			if (res) res += ", ";
			res += tag.name;
		}
		return res;
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

	//--------------------------------------
	//  keyWords
	//--------------------------------------
	private var _keyWords:String = "";
	[Bindable("keyWordsChanged")]
	public function get keyWords():String {return _keyWords;}
	public function set keyWords(value:String):void {
		if (_keyWords != value) {
			_keyWords = value;
			dispatchEvent(new Event("keyWordsChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function isFavorite():Boolean {
		for each(var tagID:int in tagIDs) {
			var tag:Tag = vocabulary.tagHash[tagID];
			if (tag && tag.name.toLowerCase().indexOf("favorite") != -1)
				return true;
		}
		return false;
	}

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
		res.langID = vocabulary.lang.id;
		res.vocabularyID = vocabulary.id;
		res.parentID = parentID;
		res.title = title;
		res.description = description;
		res.isExample = isExample;
		res.options = options;
		res.options.keyWords = keyWords || null;
		res.searchText = toSearchText(title, description);
		res.hasAudio = hasAudio;
		res.tags = tagIdsToString(tagIDs);
		return res;
	}

	public static function toSearchText(title:String, description:String):String {
		return (SEARCH_DELIMITER + title + SEARCH_DELIMITER + description + SEARCH_DELIMITER).toLocaleLowerCase();
	}

	public static function tagIdsToString(ids:Array):String {
		if (!ids || ids.length == 0) return "";

		var res:String = "";
		for (var i:int = 0; i < ids.length; i++) {
			var id:int = ids[i] as int;
			if (id) res += Tag.DELIMITER + id + Tag.DELIMITER;
		}
		return res;
	}

	private var _originalData:Object = {};
	public function get originalData():Object {return _originalData;}

	public function deserialize(data:Object):void {
		_originalData = data;
		_id = data.id;
		_audioComment.id = id;
		_audioComment.isMp3 = data.hasAudio;
		_parentID = data.parentID;
		_title = data.title;
		_description = data.description;
		_isExample = data.isExample;
		_hasAudio = data.hasAudio;
		_keyWords = data.options.keyWords || "";
		options = data.options;
		if (data.tags) _tagIDs = data.tags.split(Tag.DELIMITER);
	}

	public function validate():String {
		if (!title) {
			return NoteValidationErrorKey.EMPTY_NOTE_TITLE;
		}
		else if (!description) {
			return NoteValidationErrorKey.EMPTY_NOTE_DESCRIPTION;
		}
		else if (hasDuplicate()) {
			return NoteValidationErrorKey.NOTE_DUPLICATE;
		}
		else if (!isExample) {
			for each(var e:Note in exampleColl)
				if (!e.title) return NoteValidationErrorKey.EMPTY_EXAMPLE_TITLE;
				else if (!e.description) return NoteValidationErrorKey.EMPTY_EXAMPLE_DESCRIPTION;
		}
		return "";
	}

	public function hasDuplicate():Boolean {
		return !isExample && title && originalData.title != title && vocabulary.noteTitleHash.has(title) && vocabulary.id != VocabularyID.DE_LESSON && vocabulary.id != VocabularyID.EN_LESSON;
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
			exampleColl = reloadedNote.exampleColl;
		}
	}

	public function playAudioComment():void {
		if (hasAudio) {
			if (audioComment.hasBytes) {
				MP3Player.instance.comment = audioComment;
				MP3Player.instance.play();
			}
			else if (audioComment.isMp3) {
				audioComment.loadMP3().addCompleteCallback(mp3Loaded);
			}
		}
	}

	private function mp3Loaded(op:IAsyncOperation):void {
		if (op.isSuccess) {
			playAudioComment();
		}
	}

}
}
