package dittner.testmyself.core.model.note {
public class NoteHash {
	public function NoteHash() {}

	protected var keys:Object;

	public function init(notes:Array):void {
		this.keys = {};
		for each(var note:INote in notes) {
			keys[getKey(note)] = true;
		}
	}

	public function add(note:INote):void {
		keys[getKey(note)] = true;
	}

	public function remove(note:INote):void {
		delete keys[getKey(note)];
	}

	public function update(note:INote, origin:INote):void {
		remove(origin);
		add(note);
	}

	public function has(note:INote):Boolean {
		return keys[getKey(note)];
	}

	public function getKey(note:INote):String {
		return note.title;
	}
}
}
