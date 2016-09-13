package de.dittner.testmyself.model {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.DeferredCommandManager;
import de.dittner.testmyself.model.domain.language.DeLang;
import de.dittner.testmyself.ui.common.menu.MenuID;
import de.dittner.testmyself.ui.common.view.ViewModelFactory;
import de.dittner.testmyself.ui.common.view.ViewNavigator;
import de.dittner.testmyself.ui.view.main.MainVM;
import de.dittner.testmyself.ui.view.main.MainView;
import de.dittner.testmyself.ui.view.map.MapVM;
import de.dittner.testmyself.ui.view.noteList.NoteListVM;
import de.dittner.testmyself.ui.view.search.SearchVM;
import de.dittner.testmyself.ui.view.settings.SettingsVM;
import de.dittner.testmyself.ui.view.test.TestVM;
import de.dittner.walter.Walter;

public class Bootstrap extends Walter {
	public function Bootstrap(mainView:MainView) {
		super();
		this.mainView = mainView;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private var mainView:MainView;

	private var initOp:IAsyncOperation;
	public function start():IAsyncOperation {
		if (initOp && initOp.isProcessing) {
			return initOp;
		}
		else if (initOp && !initOp.isProcessing) {
			initOp = new AsyncOperation();
			initOp.dispatchSuccess();
			return initOp;
		}

		initOp = new AsyncOperation();
		var storage:Storage = new Storage();
		registerProxy("storage", storage);

		var appModel:AppModel = new AppModel();
		appModel.selectedLanguage = new DeLang(storage);
		registerProxy("appModel", appModel);

		registerProxy("deferredCommandManager", new DeferredCommandManager());
		var viewNavigator:ViewNavigator = new ViewNavigator();
		registerProxy("viewNavigator", viewNavigator);
		registerProxy("vmFactory", new ViewModelFactory());

		registerProxy("mainVM", new MainVM());
		registerProxy("mapVM", new MapVM());
		registerProxy("noteListVM", new NoteListVM());
		registerProxy("searchVM", new SearchVM());
		registerProxy("testVM", new TestVM());
		registerProxy("settingsVM", new SettingsVM());

		viewNavigator.selectedViewID = MenuID.MAP;
		mainView.activate();

		initOp = appModel.selectedLanguage.init();
		initOp.addCompleteCallback(initCompleteHandler);
		return initOp;
	}

	private function initCompleteHandler(op:IAsyncOperation):void {
		(getProxy("appModel") as AppModel).init();
	}

}
}
