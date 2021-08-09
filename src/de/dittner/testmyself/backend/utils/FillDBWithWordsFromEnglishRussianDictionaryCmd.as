package de.dittner.testmyself.backend.utils {
import de.dittner.async.IAsyncCommand;
import de.dittner.async.ProgressCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.cmd.RunDataBaseCmd;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.ui.common.utils.NoteFormUtils;

import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class FillDBWithWordsFromEnglishRussianDictionaryCmd extends ProgressCommand {
	public function FillDBWithWordsFromEnglishRussianDictionaryCmd() {
		super();
	}

	[Embed(source="/dictionary/englishIrregularVerbs.txt", mimeType="application/octet-stream")]
	[Bindable]
	private var IrregularVerbsClass:Class;
	private var irregularVerbsStr:String;

	[Embed(source="/dictionary/englishRussianDic.xml", mimeType="application/octet-stream")]
	[Bindable]
	private var EnglishRussianDicClass:Class;
	private var englishRussianDic:XML;

	private var verbPastFormHash:Object = {};
	private var verbParticipleFormHash:Object = {};
	private var notesToStore:Array;
	private var noteTitleHash:Object = {};
	private var enRuDicSQLConnection:SQLConnection;

	override public function execute():void {
		readIrregularVerbsFromFile();
		readAllNotesFromDic();
		writeNotesToDB();
	}

	private static const titleReg:RegExp = /<k>.+<\/k>\n *-?([A-Za-z \-]+)\n/i;
	private static const translationReg:RegExp = /gt; (.*?)( *_Ex:| *\d+&|<\/ar>)/gi;
	private static const exampleReg:RegExp = /_Ex: *(.+?)(;? *_Ex:| *\d+&gt;|<\/ar>)/gi;

	private function readIrregularVerbsFromFile():void {
		irregularVerbsStr = new IrregularVerbsClass();
		irregularVerbsStr = irregularVerbsStr.replace(/( {2,})/gi, " ");
		var verbs:Array = irregularVerbsStr.split("\n");

		for each(var item:String in verbs) {
			var verbForms:Array = item.split(", ");
			if (verbForms.length == 3) {
				verbPastFormHash[verbForms[0]] = verbForms[1];
				verbParticipleFormHash[verbForms[0]] = verbForms[2];
			}
			else {
				trace("Не достаточно значений!");
			}
		}
	}

	private function readAllNotesFromDic():void {
		notesToStore = [];
		var translationHash:Object = {};
		var examplesHash:Object = {};

		englishRussianDic = XML(new EnglishRussianDicClass);
		for each(var item:XML in englishRussianDic.ar) {
			var text:String = item.toString();
			var title:String = "";
			var translation:String = "";

			var titleData:Array = titleReg.exec(text);
			title = titleData && titleData.length > 1 ? titleData[1] : item.k;

			text = text.replace(/(\n)/gi, "");
			text = text.replace(/( {2,})/gi, " ");
			text = text.replace(/( и т\. ?п\.)/gi, "");
			text = text.replace(/(_Id:)/gi, "_Ex:");
			text = text.replace(/(_Ex:)/gi, "_Ex:_Ex:");

			var translationData:Array = translationReg.exec(text);
			while (translationData != null && translationData.length > 1) {
				translation += translationData[1] + "\n";
				translationData = translationReg.exec(text);
			}

			if (!examplesHash[title])
				examplesHash[title] = [];

			var examplesData:Array = exampleReg.exec(text);
			while (examplesData != null && examplesData.length > 1) {
				var raw:String = examplesData[1];
				raw = raw.replace(/( *_Ex: *)/gi, "");
				var ruTextInd:int = raw.search(/[А-Яа-яёЁ]/);
				if (ruTextInd != -1 && ruTextInd > 1) {
					var en:String = raw.substr(0, ruTextInd - 1).replace(/(;)/gi, ",").replace(/( {2,})/gi, " ");
					var ru:String = raw.substr(ruTextInd).replace(/(;)/gi, ",").replace(/( {2,})/gi, " ");

					if (en && (en.charAt(en.length - 1) == "," || en.charAt(en.length - 1) == ";") || en.charAt(en.length - 1) == " ")
						en = en.substr(0, en.length - 1);

					if (ru && (ru.charAt(ru.length - 1) == "," || ru.charAt(ru.length - 1) == ";") || ru.charAt(ru.length - 1) == " " || ru.charAt(ru.length - 1) == "\t")
						ru = ru.substr(0, ru.length - 1);
					examplesHash[title].push({en: en, ru: ru});
				}

				examplesData = exampleReg.exec(text);
			}

			if (translationHash[title])
				translationHash[title] = NoteFormUtils.formatText(translationHash[title] + "\n" + translation);
			else
				translationHash[title] = NoteFormUtils.formatText(translation);
		}

		for (var prop:String in translationHash)
			notesToStore.push({title: prop, description: translationHash[prop], examples: examplesHash[prop]});

		var playback:String = translationHash["playback"];

		var play:String = translationHash["play"];
		var playExamples:Array = examplesHash["play"];

		var ability:String = translationHash["ability"];
		var abilityExamples:Array = examplesHash["ability"];

		var write:String = translationHash["write"];
		var writeExamples:Array = examplesHash["write"];

		var russian:String = translationHash["Russian"];
		var russianExamples:Array = examplesHash["Russian"];

		var russian2:String = translationHash["russian"];
		var russianExamples2:Array = examplesHash["russian"];

		trace();
	}

	private function writeNotesToDB():void {
		var cmd:IAsyncCommand = new RunDataBaseCmd(Device.englishDicDBPath, SQLLib.getEnRuDicDBTables());
		cmd.addCompleteCallback(dataBaseReadyHandler);
		cmd.execute();
	}

	private function dataBaseReadyHandler(opEvent:*):void {
		enRuDicSQLConnection = opEvent.result as SQLConnection;
		total = notesToStore.length;
		storeNextNote();
	}

	public var total:Number = 0;
	public var curNote:Object;
	private const INSERT_SQL_CMD:String = "INSERT INTO enRuDic (title, description, examples) VALUES (:title, :description, :examples)";

	private function storeNextNote(result:* = null):void {
		if (notesToStore.length > 0) {
			curNote = notesToStore.pop();
			setProgress(1 - notesToStore.length / total);
			if (noteTitleHash[curNote.title]) {
				trace("Duplicate! – " + curNote.title);
				storeNextNote();
			}
			else {
				noteTitleHash[curNote.title] = true;
				var statement:SQLStatement = SQLUtils.createSQLStatement(INSERT_SQL_CMD, curNote);
				statement.sqlConnection = enRuDicSQLConnection;
				statement.execute(-1, new Responder(storeNextNote, executeError));
			}
		}
		else {
			dispatchSuccess();
		}
	}
	protected function executeError(error:SQLError):void {
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
	}

}
}