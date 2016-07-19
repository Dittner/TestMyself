package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.ui.common.renderer.SeparatorVo;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.view.about.AboutScreen;
import de.dittner.testmyself.ui.view.dictionary.lesson.LessonScreen;
import de.dittner.testmyself.ui.view.dictionary.note.NoteScreen;
import de.dittner.testmyself.ui.view.search.SearchScreen;
import de.dittner.testmyself.ui.view.settings.SettingsScreen;
import de.dittner.testmyself.ui.view.test.TestScreen;
import de.dittner.walter.WalterProxy;

import flash.display.BitmapData;

import mx.collections.ArrayCollection;

public class ViewFactory extends WalterProxy implements IViewFactory {
	[Embed(source='/assets/screen/about.png')]
	private static const AboutIconClass:Class;

	[Embed(source='/assets/screen/word.png')]
	private static const WordIconClass:Class;

	[Embed(source='/assets/screen/verb.png')]
	private static const VerbIconClass:Class;

	[Embed(source='/assets/screen/lesson.png')]
	private static const LessonIconClass:Class;

	[Embed(source='/assets/screen/testing.png')]
	private static const TestingIconClass:Class;

	[Embed(source='/assets/screen/search.png')]
	private static const SearchIconClass:Class;

	[Embed(source='/assets/screen/settings.png')]
	private static const SettingsIconClass:Class;

	public function ViewFactory():void {
		createViewInfoList();
	}

	private var _viewInfoColl:ArrayCollection;
	public function get viewInfoColl():ArrayCollection {
		return _viewInfoColl;
	}

	private function createViewInfoList():void {
		var _viewInfoArr:Array = [];
		var info:ViewInfo;

		info = new ViewInfo(ViewID.ABOUT, "", "Die Beschreibung des Programms", getIcon(ViewID.ABOUT));
		_viewInfoArr.push(info);

		_viewInfoArr.push(createViewItemSeparator());

		info = new ViewInfo(ViewID.WORD, "WÖRTERBUCH", "Wörterbuch", getIcon(ViewID.WORD));
		_viewInfoArr.push(info);

		info = new ViewInfo(ViewID.VERB, "STARKE VERBEN", "Starke Verben", getIcon(ViewID.VERB));
		_viewInfoArr.push(info);

		info = new ViewInfo(ViewID.LESSON, "ÜBUNGEN", "Übungen", getIcon(ViewID.LESSON));
		_viewInfoArr.push(info);

		_viewInfoArr.push(createViewItemSeparator());

		info = new ViewInfo(ViewID.TEST, "TESTEN", "Testen", getIcon(ViewID.TEST));
		_viewInfoArr.push(info);

		info = new ViewInfo(ViewID.SEARCH, "SUCHE", "Suche", getIcon(ViewID.SEARCH));
		_viewInfoArr.push(info);

		_viewInfoArr.push(createViewItemSeparator());

		info = new ViewInfo(ViewID.SETTINGS, "EINSTELLUNGEN", "Einstellungen", getIcon(ViewID.SETTINGS));
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
			case ViewID.ABOUT :
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

	private static var noteScreen:NoteScreen = new NoteScreen();
	private static var lessonScreen:LessonScreen = new LessonScreen();
	private static var testScreen:TestScreen = new TestScreen();
	private static var searchScreen:SearchScreen = new SearchScreen();
	public function createView(viewInfo:ViewInfo):ViewBase {
		var view:ViewBase;
		switch (viewInfo.id) {
			case ViewID.ABOUT :
				view = new AboutScreen();
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
				view = new SettingsScreen();
				break;
			default :
				throw new Error("Unknown screen ID:" + viewInfo.id);
		}

		view.info = viewInfo;
		return view;
	}

}
}
