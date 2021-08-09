package de.dittner.testmyself.backend.utils {
import de.dittner.async.IAsyncOperation;
import de.dittner.async.ProgressCommand;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.cmd.StoreNoteCmd;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.walter.Walter;

import flash.data.SQLResult;

public class AddLessonNotesToDBFromFileCmd extends ProgressCommand {
	public function AddLessonNotesToDBFromFileCmd(storage:Storage, lang:Language) {
		super();
		this.storage = storage;
		Walter.instance.injector.inject(this);

		vocabulary = lang.vocabularyHash.read(VocabularyID.DE_LESSON) as Vocabulary;
		selectedTag = vocabulary.tagNameHash["Übungen. Rektion der Verben"];
		selectedTagIDs = [selectedTag.id];
		trace();
	}

	[Inject]
	public var appModel:AppModel;
	private var vocabulary:Vocabulary;

	[Embed(source="/dictionary/1.txt", mimeType="application/octet-stream")]
	[Bindable]
	private var VerbsClass:Class;
	private var verbsStr:String;

	[Embed(source="/dictionary/2.txt", mimeType="application/octet-stream")]
	[Bindable]
	private var TranslatesClass:Class;
	private var translatesStr:String;

	[Embed(source="/dictionary/3.txt", mimeType="application/octet-stream")]
	[Bindable]
	private var ExamplesClass:Class;
	private var examplesStr:String;

	private var notesToStore:Array;
	private var selectedTag:Tag;
	private var selectedTagIDs:Array;
	private var storage:Storage;

	override public function execute():void {
		verbsStr = new VerbsClass();
		translatesStr = new TranslatesClass();
		examplesStr = new ExamplesClass();

		verbsStr = verbsStr.replace(/( {2,})/gi, " ");
		translatesStr = translatesStr.replace(/( {2,})/gi, " ");
		examplesStr = examplesStr.replace(/( {2,})/gi, " ");

		var verbs:Array = verbsStr.split("\n");
		var translates:Array = translatesStr.split("\n");
		var examples:Array = examplesStr.split("\n");
		notesToStore = [];

		for (var i:int = 0; i < verbs.length; i++) {
			var verb:String = verbs[i];
			var translate:String = translates[i];
			var example:String = examples[i];

			var offset:int = 0;
			if (verb.indexOf("sich ") == 0) {
				offset = 5
			}
			else if (verb.indexOf("(sich) ") == 0) {
				offset = 7
			}
			var ind:int = verb.indexOf(" ", offset);
			var head:String = verb.substr(0, ind);
			//var tail:String = verb.substr(ind, verb.length - 1);

			var n:Note = vocabulary.createNote() as Note;
			n.title = "<b>" + head + "</b>" + "\n" + translate;
			n.description = "<b>" + verb + "</b>" + "\n" + example;
			n.tagIDs = selectedTagIDs;

			notesToStore.push(n);
		}

		total = notesToStore.length;
		storeNextNote();
	}

	public var total:Number = 0;
	public var curNote:Note;
	private function storeNextNote(result:SQLResult = null):void {
		if (notesToStore.length > 0) {
			curNote = notesToStore.pop();
			setProgress(1 - notesToStore.length / total);
			storeNote(curNote);
		}
		else {
			dispatchSuccess();
		}
	}

	private function storeNote(note:Note):void {
		var cmd:StoreNoteCmd = new StoreNoteCmd(storage, note);
		cmd.addCompleteCallback(completeHandler);
		cmd.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) {
			storeNextNote();
			if (notesToStore.length % 100 == 0)
				CLog.info(LogTag.LOAD, "Processing " + notesToStore.length + " notes");
		}
		else {
			CLog.info(LogTag.LOAD, "Error by adding word " + curNote.title + ": " + op.error);
			dispatchError();
		}
	}

}
}