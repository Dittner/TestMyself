package de.dittner.testmyself.model.domain.theme {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.domain_internal;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.view.noteList.components.form.NoteValidationErrorKey;

use namespace domain_internal;

public class Theme {
	public function Theme() {}

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
	public function get name():String {return _name;}
	public function set name(value:String):void {_name = value;}

	//--------------------------------------
	//  vocabulary
	//--------------------------------------
	private var _vocabulary:Vocabulary;
	public function get vocabulary():Vocabulary {return _vocabulary;}
	public function set vocabulary(value:Vocabulary):void {_vocabulary = value;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function store():IAsyncOperation {
		var op:IAsyncOperation = vocabulary.storage.storeTheme(this);
		if (isNew) op.addCompleteCallback(newThemeStored);
		return op;
	}

	private function newThemeStored(op:IAsyncOperation):void {
		vocabulary.addThemeToList(this);
	}

	public function remove():IAsyncOperation {
		var op:IAsyncOperation = vocabulary.storage.removeTheme(this);
		op.addCompleteCallback(themeRemoved);
		return op;
	}

	private function themeRemoved(op:IAsyncOperation):void {
		vocabulary.removeThemeFromList(this);
	}

	public function mergeWith(theme:Theme):IAsyncOperation {
		var op:IAsyncOperation = vocabulary.storage.mergeThemes(this, theme);
		op.addCompleteCallback(function (op:IAsyncOperation):void {
			vocabulary.removeThemeFromList(theme);
		});
		return op;
	}

	public function serialize():Object {
		var res:Object = {};
		res.id = id;
		res.vocabularyID = vocabulary.id;
		res.name = name;
		return res;
	}

	public function deserialize(data:Object):void {
		_id = data.id;
		_name = data.name;
	}

	public function validate():String {
		if (!name) return NoteValidationErrorKey.EMPTY_THEME_NAME;
		else if (isNew) {
			for each(var t:Theme in vocabulary.themeColl)
				if (t.name == name) return NoteValidationErrorKey.THEME_NAME_DUPLICATE;
		}
		return "";
	}

}
}
