package de.dittner.testmyself.model {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.language.DeLang;
import de.dittner.testmyself.ui.common.view.ViewFactory;
import de.dittner.testmyself.ui.common.view.ViewModelFactory;
import de.dittner.testmyself.ui.common.view.ViewNavigator;
import de.dittner.testmyself.ui.view.main.MainVM;
import de.dittner.testmyself.ui.view.main.MainView;
import de.dittner.testmyself.ui.view.map.MapVM;
import de.dittner.testmyself.ui.view.noteList.NoteListVM;
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
		var storage:SQLStorage = new SQLStorage();
		registerProxy("storage", storage);

		var appModel:AppModel = new AppModel();
		appModel.selectedLanguage = new DeLang(storage);
		registerProxy("appModel", appModel);

		registerProxy("viewNavigator", new ViewNavigator());
		registerProxy("viewFactory", new ViewFactory());
		registerProxy("vmFactory", new ViewModelFactory());

		registerProxy("mainVM", new MainVM());
		registerProxy("mapVM", new MapVM());
		registerProxy("noteListVM", new NoteListVM());

		initOp = appModel.selectedLanguage.init();
		initOp.addCompleteCallback(initCompelteHandler);
		return initOp;
	}

	private function initCompelteHandler(op:IAsyncOperation) {
		var viewNavigator:ViewNavigator = getProxy("viewNavigator") as ViewNavigator;
		var viewFactory:ViewFactory = getProxy("viewFactory") as ViewFactory;
		viewNavigator.navigate(viewFactory.firstViewInfo);
		mainView.activate();
	}

}
}
