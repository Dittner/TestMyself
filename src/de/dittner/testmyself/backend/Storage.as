package de.dittner.testmyself.backend {
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.cmd.ClearTestHistoryCmd;
import de.dittner.testmyself.backend.cmd.LoadAllThemesCmd;
import de.dittner.testmyself.backend.cmd.LoadNoteByNoteIDCmd;
import de.dittner.testmyself.backend.cmd.LoadNotePageCmd;
import de.dittner.testmyself.backend.cmd.LoadTaskIDsCmd;
import de.dittner.testmyself.backend.cmd.LoadTestStatisticsCmd;
import de.dittner.testmyself.backend.cmd.LoadTestTaskCmd;
import de.dittner.testmyself.backend.cmd.LoadVocabularyInfoCmd;
import de.dittner.testmyself.backend.cmd.MergeThemesCmd;
import de.dittner.testmyself.backend.cmd.RemoveNoteCmd;
import de.dittner.testmyself.backend.cmd.RemoveNotesByThemeCmd;
import de.dittner.testmyself.backend.cmd.RemoveThemeCmd;
import de.dittner.testmyself.backend.cmd.RunDataBaseCmd;
import de.dittner.testmyself.backend.cmd.SearchNotesCmd;
import de.dittner.testmyself.backend.cmd.SelectAllNotesTitlesCmd;
import de.dittner.testmyself.backend.cmd.StoreNoteCmd;
import de.dittner.testmyself.backend.cmd.StoreTestTaskCmd;
import de.dittner.testmyself.backend.cmd.StoreThemeCmd;
import de.dittner.testmyself.backend.deferredOperation.IDeferredCommandManager;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.model.domain.theme.Theme;
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

	private var _sqlConnection:SQLConnection;
	public function get sqlConnection():SQLConnection {return _sqlConnection;}

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
		if (sqlConnection) {
			sqlConnection.close();
		}

		var cmd:IAsyncCommand = new RunDataBaseCmd(SQLLib.getTables());
		cmd.addCompleteCallback(dataBaseReadyHandler);
		cmd.execute();
		return cmd;
	}

	private function dataBaseReadyHandler(opEvent:*):void {
		_sqlConnection = opEvent.result as SQLConnection;
		deferredCommandManager.start();
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

	public function removeNotesByTheme(theme:Theme):IAsyncOperation {
		var op:IAsyncCommand = new RemoveNotesByThemeCmd(this, theme);
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

	//--------------------------------------
	//  Themes
	//--------------------------------------

	public function storeTheme(theme:Theme):IAsyncOperation {
		var op:IAsyncCommand = new StoreThemeCmd(this, theme);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadAllThemes(vocabulary:Vocabulary):IAsyncOperation {
		var op:IAsyncCommand = new LoadAllThemesCmd(this, vocabulary);
		deferredCommandManager.add(op);
		return op;
	}

	public function removeTheme(theme:Theme):IAsyncOperation {
		var op:IAsyncCommand = new RemoveThemeCmd(this, theme);
		deferredCommandManager.add(op);
		return op;
	}

	public function mergeThemes(destTheme:Theme, srcTheme:Theme):IAsyncOperation {
		var op:IAsyncCommand = new MergeThemesCmd(this, destTheme, srcTheme);
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

	public function loadTaskIDs(test:Test, filter:Theme, taskComplexity:uint):IAsyncOperation {
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

}
}