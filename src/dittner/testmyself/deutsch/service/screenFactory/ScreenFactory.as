package dittner.testmyself.deutsch.service.screenFactory {
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.deutsch.view.about.AboutScreen;
import dittner.testmyself.deutsch.view.common.renderer.SeparatorVo;
import dittner.testmyself.deutsch.view.common.screen.ScreenBase;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.dictionary.lesson.LessonScreen;
import dittner.testmyself.deutsch.view.dictionary.note.NoteScreen;
import dittner.testmyself.deutsch.view.settings.SettingsScreen;
import dittner.testmyself.deutsch.view.test.TestScreen;

import flash.display.BitmapData;

public class ScreenFactory extends SFProxy implements IScreenFactory {
	[Embed(source='/assets/screen/about.png')]
	private static const AboutIconClass:Class;

	[Embed(source='/assets/screen/word.png')]
	private static const WordIconClass:Class;

	[Embed(source='/assets/screen/phrase.png')]
	private static const PhraseIconClass:Class;

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

	public function ScreenFactory():void {
		createScreenInfos();
	}

	private var screensHash:Object;
	private var _screenInfos:Array;
	public function get screenInfos():Array {
		return _screenInfos;
	}

	private function createScreenInfos():void {
		_screenInfos = [];
		screensHash = {};
		var info:ScreenInfo;

		info = new ScreenInfo(ScreenID.ABOUT, "", "Описание программы и базы данных", getIcon(ScreenID.ABOUT));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		_screenInfos.push(createScreenItemSeparator());

		info = new ScreenInfo(ScreenID.WORD, "СЛОВАРЬ СЛОВ", "Словарь слов", getIcon(ScreenID.WORD));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenID.PHRASE, "СЛОВАРЬ ФРАЗ И ПРЕДЛОЖЕНИЙ", "Словарь фраз и предложений", getIcon(ScreenID.PHRASE));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenID.VERB, "ТАБЛИЦА СИЛЬНЫХ ГЛАГОЛОВ", "Таблица сильных глаголов", getIcon(ScreenID.VERB));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenID.LESSON, "УРОКИ", "Список уроков", getIcon(ScreenID.LESSON));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenID.TEST, "ТЕСТИРОВАНИЕ", "Тестирование", getIcon(ScreenID.TEST));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		_screenInfos.push(createScreenItemSeparator());

		/*info = new ScreenInfo(ScreenId.SEARCH, "ПОИСК", "Поиск в базе данных", getIcon(ScreenId.SEARCH));
		 _screenInfos.push(info);
		 screensHash[info.id] = info;*/

		info = new ScreenInfo(ScreenID.SETTINGS, "НАСТРОЙКИ", "Настройки программы", getIcon(ScreenID.SETTINGS));
		_screenInfos.push(info);
		screensHash[info.id] = info;
	}

	private function createScreenItemSeparator():SeparatorVo {
		return new SeparatorVo(0, 50, AppColors.SCREEN_LIST_BG, 1);
	}

	private function getIcon(screenId:String):BitmapData {
		var bitmapData:BitmapData = new BitmapData(50, 50, true, 0x00ffffff);
		var IconClass:Class;
		switch (screenId) {
			case ScreenID.ABOUT :
				IconClass = AboutIconClass;
				break;
			case ScreenID.WORD :
				IconClass = WordIconClass;
				break;
			case ScreenID.PHRASE :
				IconClass = PhraseIconClass;
				break;
			case ScreenID.VERB :
				IconClass = VerbIconClass;
				break;
			case ScreenID.LESSON :
				IconClass = LessonIconClass;
				break;
			case ScreenID.TEST :
				IconClass = TestingIconClass;
				break;
			case ScreenID.SEARCH :
				IconClass = SearchIconClass;
				break;
			case ScreenID.SETTINGS :
				IconClass = SettingsIconClass;
				break;
			default :
				throw new Error("Unknown screen ID:" + screenId);
		}
		bitmapData.draw(new IconClass());
		return bitmapData;
	}

	private static var noteScreen:NoteScreen = new NoteScreen();
	private static var lessonScreen:LessonScreen = new LessonScreen();
	private static var testScreen:TestScreen = new TestScreen();
	public function createScreen(screenId:String):ScreenBase {
		var screen:ScreenBase;
		switch (screenId) {
			case ScreenID.ABOUT :
				screen = new AboutScreen();
				break;
			case ScreenID.WORD :
				screen = noteScreen;
				break;
			case ScreenID.PHRASE :
				screen = noteScreen;
				break;
			case ScreenID.VERB :
				screen = noteScreen;
				break;
			case ScreenID.LESSON :
				screen = lessonScreen;
				break;
			case ScreenID.TEST :
				screen = testScreen;
				break;
			case ScreenID.SEARCH :
				screen = null;
				break;
			case ScreenID.SETTINGS :
				screen = new SettingsScreen();
				break;
			default :
				throw new Error("Unknown screen ID:" + screenId);
		}

		screen.title = screensHash[screenId].title;
		return screen;
	}

}
}
