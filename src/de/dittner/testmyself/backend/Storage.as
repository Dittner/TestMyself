package de.dittner.testmyself.backend {
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.cmd.ClearTestHistoryCmd;
import de.dittner.testmyself.backend.cmd.LoadAllTagsCmd;
import de.dittner.testmyself.backend.cmd.LoadAudioCommentCmd;
import de.dittner.testmyself.backend.cmd.LoadHashDataCmd;
import de.dittner.testmyself.backend.cmd.LoadNoteByNoteIDCmd;
import de.dittner.testmyself.backend.cmd.LoadNotePageCmd;
import de.dittner.testmyself.backend.cmd.LoadTaskIDsCmd;
import de.dittner.testmyself.backend.cmd.LoadTestStatisticsCmd;
import de.dittner.testmyself.backend.cmd.LoadTestTaskCmd;
import de.dittner.testmyself.backend.cmd.LoadVocabularyInfoCmd;
import de.dittner.testmyself.backend.cmd.MergeTagsCmd;
import de.dittner.testmyself.backend.cmd.RemoveNoteCmd;
import de.dittner.testmyself.backend.cmd.RemoveNotesByTagCmd;
import de.dittner.testmyself.backend.cmd.RemoveTagCmd;
import de.dittner.testmyself.backend.cmd.RunDataBaseCmd;
import de.dittner.testmyself.backend.cmd.SearchNotesCmd;
import de.dittner.testmyself.backend.cmd.SelectAllNotesTitlesCmd;
import de.dittner.testmyself.backend.cmd.StoreHashDataCmd;
import de.dittner.testmyself.backend.cmd.StoreNoteCmd;
import de.dittner.testmyself.backend.cmd.StoreTagCmd;
import de.dittner.testmyself.backend.cmd.StoreTestTaskCmd;
import de.dittner.testmyself.backend.deferredOperation.IDeferredCommandManager;
import de.dittner.testmyself.backend.op.LoadAllExamplesOperation;
import de.dittner.testmyself.backend.utils.HashData;
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.common.page.NotePage;
import de.dittner.testmyself.ui.common.page.SearchPage;
import de.dittner.testmyself.ui.view.test.testing.components.TestPage;
import de.dittner.walter.WalterProxy;

import flash.data.SQLConnection;

public class Storage extends WalterProxy {
	public function Storage() {
		super();
	}

	[Inject]
	public var deferredCommandManager:IDeferredCommandManager;

	public var exampleHash:Object = {};

	private var _sqlConnection:SQLConnection;
	public function get sqlConnection():SQLConnection {return _sqlConnection;}

	private var _audioSqlConnection:SQLConnection;
	public function get audioSqlConnection():SQLConnection {return _audioSqlConnection;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function activate():void {
		deferredCommandManager.stop();
		reloadDataBase();
	}

	public function reloadDataBase():IAsyncOperation {
		exampleHash = {};

		if (sqlConnection) {
			sqlConnection.close();
		}

		if (audioSqlConnection) {
			audioSqlConnection.close();
		}

		var cmd:IAsyncCommand = new RunDataBaseCmd(Device.noteDBPath, SQLLib.getNoteDBTables());
		cmd.addCompleteCallback(dataBaseReadyHandler);
		cmd.execute();

		/*var changeNoteCmd:TransferNoteAudioToOtherTblCmd = new TransferNoteAudioToOtherTblCmd(this);
		 deferredCommandManager.add(changeNoteCmd);*/

		return cmd;
	}

	private function dataBaseReadyHandler(opEvent:*):void {
		_sqlConnection = opEvent.result as SQLConnection;

		var cmd:IAsyncCommand = new RunDataBaseCmd(Device.audioDBPath, SQLLib.getAudioDBTables());
		cmd.addCompleteCallback(audioDataBaseReadyHandler);
		cmd.execute();
	}

	private function audioDataBaseReadyHandler(opEvent:*):void {
		_audioSqlConnection = opEvent.result as SQLConnection;
		deferredCommandManager.start();
		var cmd:LoadAllExamplesOperation = new LoadAllExamplesOperation(this);
		deferredCommandManager.add(cmd);
	}

	public function loadVocabularyInfo(v:Vocabulary):IAsyncOperation {
		var op:IAsyncCommand = new LoadVocabularyInfoCmd(this, v);
		deferredCommandManager.add(op);
		return op;
	}

	//--------------------------------------
	//  Notes
	//--------------------------------------

	public function storeNote(note:Note):IAsyncOperation {
		var op:IAsyncCommand = new StoreNoteCmd(this, note);
		deferredCommandManager.add(op);
		return op;
	}

	public function removeNote(note:Note):IAsyncOperation {
		var op:IAsyncCommand = new RemoveNoteCmd(this, note.id);
		deferredCommandManager.add(op);
		return op;
	}

	public function removeNotesByTag(tag:Tag):IAsyncOperation {
		var op:IAsyncCommand = new RemoveNotesByTagCmd(this, tag);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadNotePage(page:NotePage):IAsyncOperation {
		var op:IAsyncCommand = new LoadNotePageCmd(this, page);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadAllNotesTitles(v:Vocabulary):IAsyncOperation {
		var op:IAsyncCommand = new SelectAllNotesTitlesCmd(this, v);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadNote(v:Vocabulary, noteID:int):IAsyncOperation {
		var op:IAsyncCommand = new LoadNoteByNoteIDCmd(this, v, noteID);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadAudioComment(note:Note):IAsyncOperation {
		var op:IAsyncCommand = new LoadAudioCommentCmd(this, note);
		deferredCommandManager.add(op);
		return op;
	}

	//--------------------------------------
	//  Tags
	//--------------------------------------

	public function storeTag(tag:Tag):IAsyncOperation {
		var op:IAsyncCommand = new StoreTagCmd(this, tag);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadAllTags(vocabulary:Vocabulary):IAsyncOperation {
		var op:IAsyncCommand = new LoadAllTagsCmd(this, vocabulary);
		deferredCommandManager.add(op);
		return op;
	}

	public function removeTag(tag:Tag):IAsyncOperation {
		var op:IAsyncCommand = new RemoveTagCmd(this, tag);
		deferredCommandManager.add(op);
		return op;
	}

	public function mergeTags(srcTag:Tag, destTag:Tag):IAsyncOperation {
		var op:IAsyncCommand = new MergeTagsCmd(this, srcTag, destTag);
		deferredCommandManager.add(op);
		return op;
	}

	//--------------------------------------
	//  search
	//--------------------------------------

	public function searchNotes(page:SearchPage):IAsyncOperation {
		var op:IAsyncCommand = new SearchNotesCmd(this, page);
		deferredCommandManager.add(op);
		return op;
	}

	//--------------------------------------
	//  test
	//--------------------------------------

	public function storeTestTask(task:TestTask):IAsyncOperation {
		var op:IAsyncCommand = new StoreTestTaskCmd(this, task);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadTestStatistics(page:TestPage):IAsyncOperation {
		var op:IAsyncCommand = new LoadTestStatisticsCmd(this, page);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadTaskIDs(test:Test, filter:Tag, taskComplexity:uint):IAsyncOperation {
		var op:IAsyncCommand = new LoadTaskIDsCmd(this, test, filter, taskComplexity);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadTestTask(test:Test, taskID:int):IAsyncOperation {
		var op:IAsyncCommand = new LoadTestTaskCmd(this, test, taskID);
		deferredCommandManager.add(op);
		return op;
	}

	public function clearTestHistory(test:Test):IAsyncOperation {
		var op:IAsyncCommand = new ClearTestHistoryCmd(this, test);
		deferredCommandManager.add(op);
		return op;
	}

	//--------------------------------------
	//  hash
	//--------------------------------------

	public function store(hashData:HashData):IAsyncOperation {
		var cmd:IAsyncCommand = new StoreHashDataCmd(this, hashData);
		cmd.execute();
		return cmd;
	}

	public function load(hashDataKey:String):IAsyncOperation {
		var cmd:IAsyncCommand = new LoadHashDataCmd(this, hashDataKey);
		cmd.execute();
		return cmd;
	}

}
}