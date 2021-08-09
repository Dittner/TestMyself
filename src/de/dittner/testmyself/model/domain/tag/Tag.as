package de.dittner.testmyself.model.domain.tag {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.domain_internal;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.view.form.components.NoteValidationErrorKey;

import flash.events.Event;
import flash.events.EventDispatcher;

use namespace domain_internal;

public class Tag extends EventDispatcher {
	public function Tag() {
		super();
	}

	public static const DELIMITER:String = ",";

	//--------------------------------------
	//  id
	//--------------------------------------
	private var _id:int = -1;
	public function get id():int {return _id;}
	public function set id(value:int):void {_id = value;}

	//--------------------------------------
	//  isNew
	//--------------------------------------
	public function get isNew():Boolean {return _id == -1;}

	//--------------------------------------
	//  name
	//--------------------------------------
	private var _name:String = "";
	[Bindable("nameChanged")]
	public function get name():String {return _name;}
	public function set name(value:String):void {
		if (_name != value) {
			_name = value;
			dispatchEvent(new Event("nameChanged"));
		}
	}

	//--------------------------------------
	//  category
	//--------------------------------------
	private static const categoryReg:RegExp = /(A|B|C)(1|2).*/i;
	public function getCategory():String {
		if (categoryReg.test(name)) {
			var regRes:Array = categoryReg.exec(name);
			if (regRes.length > 2)
				return regRes[1] + regRes[2];
		}
		return ""
	}

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

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function store():IAsyncOperation {
		return vocabulary.storage.storeTag(this);
	}

	public function remove():IAsyncOperation {
		return vocabulary.storage.removeTag(this);
	}

	public function mergeWith(tag:Tag):IAsyncOperation {
		return vocabulary.storage.mergeTags(tag, this);
	}

	public function serialize():Object {
		var res:Object = {};
		res.vocabularyID = vocabulary.id;
		res.name = name;
		return res;
	}

	public function deserialize(data:Object):void {
		_id = data.id;
		_name = data.name;
	}

	public function validate():String {
		if (!name) return NoteValidationErrorKey.EMPTY_TAG_NAME;
		else if (isNew) {
			for each(var t:Tag in vocabulary.tagColl)
				if (t.name == name) return NoteValidationErrorKey.TAG_NAME_DUPLICATE;
		}
		return "";
	}

}
}
