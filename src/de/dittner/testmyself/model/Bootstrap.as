package de.dittner.testmyself.model {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.DeferredCommandManager;
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModelFactory;
import de.dittner.testmyself.ui.view.form.NoteFormVM;
import de.dittner.testmyself.ui.view.info.InfoVM;
import de.dittner.testmyself.ui.view.lessonTagList.LessonTagListVM;
import de.dittner.testmyself.ui.view.main.MainVM;
import de.dittner.testmyself.ui.view.main.MainView;
import de.dittner.testmyself.ui.view.map.MapVM;
import de.dittner.testmyself.ui.view.noteList.NoteListVM;
import de.dittner.testmyself.ui.view.noteView.NoteViewVM;
import de.dittner.testmyself.ui.view.search.SearchVM;
import de.dittner.testmyself.ui.view.settings.SettingsVM;
import de.dittner.testmyself.ui.view.testList.TestListVM;
import de.dittner.testmyself.ui.view.testPresets.TestPresetsVM;
import de.dittner.testmyself.ui.view.testStatistics.TestStatisticsVM;
import de.dittner.testmyself.ui.view.testing.TestingVM;
import de.dittner.walter.Walter;

import flash.events.Event;

import mx.core.FlexGlobals;

import spark.components.Application;

public class Bootstrap extends Walter {
	public function Bootstrap() {
		super();
	}

	private var mainView:MainView;
	private var storage:Storage;
	private var appModel:AppModel;

	public function start():void {
		storage = new Storage();
		registerProxy("storage", storage);

		appModel = new AppModel();
		registerProxy("appModel", appModel);

		registerProxy("deferredCommandManager", new DeferredCommandManager());
		registerProxy("vmFactory", new ViewModelFactory());

		registerProxy("mainVM", new MainVM());

		registerProxy("infoVM", new InfoVM());
		registerProxy("mapVM", new MapVM());

		registerProxy("noteViewVM", new NoteViewVM());
		registerProxy("noteFormVM", new NoteFormVM());
		registerProxy("wordListVM", new NoteListVM());
		registerProxy("verbListVM", new NoteListVM());
		registerProxy("lessonListVM", new NoteListVM());
		registerProxy("lessonTagListVM", new LessonTagListVM());

		registerProxy("testListVM", new TestListVM());
		registerProxy("testPresetsVM", new TestPresetsVM());
		registerProxy("testStatisticsVM", new TestStatisticsVM());
		registerProxy("testingVM", new TestingVM());

		registerProxy("searchVM", new SearchVM());
		registerProxy("settingsVM", new SettingsVM());

		reloadStorage();
	}

	private function reloadStorage():void{
		var op:IAsyncOperation = storage.reloadDataBase();
		op.addCompleteCallback(storageReady);
	}

	private function storageReady(op:IAsyncOperation):void{
		var op:IAsyncOperation = appModel.init();
		op.addCompleteCallback(modelInitialized);
	}

	private function modelInitialized(op:IAsyncOperation):void {
		Device.stage.addEventListener(Event.RESIZE, onResize);
		mainView = new MainView();
		mainView.width = Device.width;
		mainView.height = Device.height;

		(FlexGlobals.topLevelApplication as Application).addElement(mainView);
		mainView.activate();
		mainView.viewNavigator.navigate(new ViewInfo(ViewID.INFO));
	}

	private function onResize(event:Event):void {
		mainView.width = Device.width;
		mainView.height = Device.height;
	}
}
}
