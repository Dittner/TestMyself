package de.dittner.testmyself.model.domain.note.verb {
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.ui.view.noteList.components.form.NoteValidationErrorKey;

public class DeVerb extends Note {
	public function DeVerb():void {}

	//--------------------------------------
	//  present
	//--------------------------------------
	private var _present:String = "";
	public function get present():String {return _present;}
	public function set present(value:String):void {
		_present = value || "";
	}

	//--------------------------------------
	//  past
	//--------------------------------------
	private var _past:String = "";
	public function get past():String {return _past;}
	public function set past(value:String):void {
		_past = value || "";
	}

	//--------------------------------------
	//  perfect
	//--------------------------------------
	private var _perfect:String = "";
	public function get perfect():String {return _perfect;}
	public function set perfect(value:String):void {
		_perfect = value || "";
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function serialize():Object {
		var res:Object = super.serialize();
		res.options.present = present || null;
		res.options.past = past || null;
		res.options.perfect = perfect || null;
		res.searchText = title + description + present + past + perfect;
		return res;
	}

	override public function deserialize(data:Object):void {
		super.deserialize(data);
		present = data.options.present || "";
		past = data.options.past = past || "";
		perfect = data.options.perfect = perfect || "";
	}

	override public function validate():String {
		if (!present || !past || !perfect)
			return NoteValidationErrorKey.EMPTY_VERB_FIELDS;
		else
			return super.validate();
	}

}
}
