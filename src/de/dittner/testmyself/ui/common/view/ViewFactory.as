package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.ui.common.renderer.SeparatorVo;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.view.map.MapView;
import de.dittner.testmyself.ui.view.noteList.LessonView;
import de.dittner.testmyself.ui.view.noteList.NoteListView;
import de.dittner.testmyself.ui.view.search.SearchView;
import de.dittner.testmyself.ui.view.settings.SettingsView;
import de.dittner.testmyself.ui.view.test.TestView;
import de.dittner.walter.WalterProxy;

import flash.display.BitmapData;

import mx.collections.ArrayCollection;

public class ViewFactory extends WalterProxy implements IViewFactory {
	[Embed(source='/assets/screen/about.png')]
	private static const AboutIconClass:Class;
	[Embed(source='/assets/screen/about_red.png')]
	private static const AboutDisabledIconClass:Class;

	[Embed(source='/assets/screen/word.png')]
	private static const WordIconClass:Class;
	[Embed(source='/assets/screen/word_red.png')]
	private static const WordDisabledIconClass:Class;

	[Embed(source='/assets/screen/verb.png')]
	private static const VerbIconClass:Class;
	[Embed(source='/assets/screen/verb_red.png')]
	private static const VerbDisabledIconClass:Class;

	[Embed(source='/assets/screen/lesson.png')]
	private static const LessonIconClass:Class;
	[Embed(source='/assets/screen/lesson_red.png')]
	private static const LessonDisabledIconClass:Class;

	[Embed(source='/assets/screen/testing.png')]
	private static const TestingIconClass:Class;
	[Embed(source='/assets/screen/testing_red.png')]
	private static const TestingDisabledIconClass:Class;

	[Embed(source='/assets/screen/search.png')]
	private static const SearchIconClass:Class;
	[Embed(source='/assets/screen/search_red.png')]
	private static const SearchDisabledIconClass:Class;

	[Embed(source='/assets/screen/settings.png')]
	private static const SettingsIconClass:Class;
	[Embed(source='/assets/screen/settings_red.png')]
	private static const SettingsDisabledIconClass:Class;

	public static var instance:ViewFactory;

	public function ViewFactory():void {
		super();
		if (instance) throw  new Error("ViewFactory must be Singleton!");
		instance = this;
		createViewInfoList();
	}

	private var _viewInfoColl:ArrayCollection;
	public function get viewInfoColl():ArrayCollection {
		return _viewInfoColl;
	}

	private var _firstViewInfo:ViewInfo;
	public function get firstViewInfo():ViewInfo {return _firstViewInfo;}

	private function createViewInfoList():void {
		var _viewInfoArr:Array = [];
		var info:ViewInfo;

		info = new ViewInfo(ViewID.MAP, "", "Die Beschreibung des Programms", getIcon(ViewID.MAP), getDisabledIcon(ViewID.MAP));
		_firstViewInfo = info;
		_viewInfoArr.push(info);

		_viewInfoArr.push(createViewItemSeparator());

		info = new ViewInfo(ViewID.WORD, "WÖRTERBUCH", "Wörterbuch", getIcon(ViewID.WORD), getDisabledIcon(ViewID.WORD));
		_viewInfoArr.push(info);

		info = new ViewInfo(ViewID.VERB, "STARKE VERBEN", "Starke Verben", getIcon(ViewID.VERB), getDisabledIcon(ViewID.VERB));
		_viewInfoArr.push(info);

		info = new ViewInfo(ViewID.LESSON, "ÜBUNGEN", "Übungen", getIcon(ViewID.LESSON), getDisabledIcon(ViewID.LESSON));
		_viewInfoArr.push(info);

		_viewInfoArr.push(createViewItemSeparator());

		info = new ViewInfo(ViewID.TEST, "TESTEN", "Testen", getIcon(ViewID.TEST), getDisabledIcon(ViewID.TEST));
		_viewInfoArr.push(info);

		info = new ViewInfo(ViewID.SEARCH, "SUCHE", "Suche", getIcon(ViewID.SEARCH), getDisabledIcon(ViewID.SEARCH));
		_viewInfoArr.push(info);

		_viewInfoArr.push(createViewItemSeparator());

		info = new ViewInfo(ViewID.SETTINGS, "EINSTELLUNGEN", "Einstellungen", getIcon(ViewID.SETTINGS), getDisabledIcon(ViewID.SETTINGS));
		_viewInfoArr.push(info);

		_viewInfoColl = new ArrayCollection(_viewInfoArr);
	}

	private function createViewItemSeparator():SeparatorVo {
		return new SeparatorVo(0, 50, AppColors.VIEW_LIST_BG, 1);
	}

	private function getIcon(viewID:String):BitmapData {
		var bitmapData:BitmapData = new BitmapData(50, 50, true, 0x00ffffff);
		var IconClass:Class;
		switch (viewID) {
			case ViewID.MAP :
				IconClass = AboutIconClass;
				break;
			case ViewID.WORD :
				IconClass = WordIconClass;
				break;
			case ViewID.VERB :
				IconClass = VerbIconClass;
				break;
			case ViewID.LESSON :
				IconClass = LessonIconClass;
				break;
			case ViewID.TEST :
				IconClass = TestingIconClass;
				break;
			case ViewID.SEARCH :
				IconClass = SearchIconClass;
				break;
			case ViewID.SETTINGS :
				IconClass = SettingsIconClass;
				break;
			default :
				throw new Error("Unknown view ID:" + viewID);
		}
		bitmapData.draw(new IconClass());
		return bitmapData;
	}

	private function getDisabledIcon(viewID:String):BitmapData {
		var bitmapData:BitmapData = new BitmapData(50, 50, true, 0x00ffffff);
		var IconClass:Class;
		switch (viewID) {
			case ViewID.MAP :
				IconClass = AboutDisabledIconClass;
				break;
			case ViewID.WORD :
				IconClass = WordDisabledIconClass;
				break;
			case ViewID.VERB :
				IconClass = VerbDisabledIconClass;
				break;
			case ViewID.LESSON :
				IconClass = LessonDisabledIconClass;
				break;
			case ViewID.TEST :
				IconClass = TestingDisabledIconClass;
				break;
			case ViewID.SEARCH :
				IconClass = SearchDisabledIconClass;
				break;
			case ViewID.SETTINGS :
				IconClass = SettingsDisabledIconClass;
				break;
			default :
				throw new Error("Unknown view ID:" + viewID);
		}
		bitmapData.draw(new IconClass());
		return bitmapData;
	}

	private static var noteScreen:NoteListView = new NoteListView();
	private static var lessonScreen:LessonView = new LessonView();
	private static var testScreen:TestView = new TestView();
	private static var searchScreen:SearchView = new SearchView();
	public function createView(viewInfo:ViewInfo):ViewBase {
		var view:ViewBase;
		switch (viewInfo.id) {
			case ViewID.MAP :
				view = new MapView();
				break;
			case ViewID.WORD :
				view = noteScreen;
				break;
			case ViewID.VERB :
				view = noteScreen;
				break;
			case ViewID.LESSON :
				view = lessonScreen;
				break;
			case ViewID.TEST :
				view = testScreen;
				break;
			case ViewID.SEARCH :
				view = searchScreen;
				break;
			case ViewID.SETTINGS :
				view = new SettingsView();
				break;
			default :
				throw new Error("Unknown screen ID:" + viewInfo.id);
		}

		view.info = viewInfo;
		return view;
	}

}
}
