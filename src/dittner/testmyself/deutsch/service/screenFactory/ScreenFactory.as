package dittner.testmyself.deutsch.service.screenFactory {
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.deutsch.view.about.AboutScreen;
import dittner.testmyself.deutsch.view.common.renderer.SeparatorVo;
import dittner.testmyself.deutsch.view.common.screen.ScreenBase;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.note.NoteScreen;
import dittner.testmyself.deutsch.view.settings.SettingsScreen;
import dittner.testmyself.deutsch.view.template.TemplateScreen;
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

		info = new ScreenInfo(ScreenIDs.ABOUT, "", "Описание программы и базы данных", getIcon(ScreenIDs.ABOUT));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		_screenInfos.push(createScreenItemSeparator());

		info = new ScreenInfo(ScreenIDs.WORD, "СЛОВАРЬ СЛОВ", "Словарь слов", getIcon(ScreenIDs.WORD));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenIDs.PHRASE, "СЛОВАРЬ ФРАЗ И ПРЕДЛОЖЕНИЙ", "Словарь фраз и предложений", getIcon(ScreenIDs.PHRASE));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenIDs.VERB, "ТАБЛИЦА СИЛЬНЫХ ГЛАГОЛОВ", "Таблица сильных глаголов", getIcon(ScreenIDs.VERB));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenIDs.TEST, "ТЕСТИРОВАНИЕ", "Тестирование", getIcon(ScreenIDs.TEST));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		_screenInfos.push(createScreenItemSeparator());

		/*info = new ScreenInfo(ScreenId.SEARCH, "ПОИСК", "Поиск в базе данных", getIcon(ScreenId.SEARCH));
		 _screenInfos.push(info);
		 screensHash[info.id] = info;*/

		info = new ScreenInfo(ScreenIDs.SETTINGS, "НАСТРОЙКИ", "Настройки программы", getIcon(ScreenIDs.SETTINGS));
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
			case ScreenIDs.ABOUT :
				IconClass = AboutIconClass;
				break;
			case ScreenIDs.WORD :
				IconClass = WordIconClass;
				break;
			case ScreenIDs.PHRASE :
				IconClass = PhraseIconClass;
				break;
			case ScreenIDs.VERB :
				IconClass = VerbIconClass;
				break;
			case ScreenIDs.TEST :
				IconClass = TestingIconClass;
				break;
			case ScreenIDs.SEARCH :
				IconClass = SearchIconClass;
				break;
			case ScreenIDs.SETTINGS :
				IconClass = SettingsIconClass;
				break;
			default :
				throw new Error("Unknown screen ID:" + screenId);
		}
		bitmapData.draw(new IconClass());
		return bitmapData;
	}

	private static var noteScreen:NoteScreen = new NoteScreen();
	private static var testScreen:TestScreen = new TestScreen();
	public function createScreen(screenId:String):ScreenBase {
		var screen:ScreenBase;
		switch (screenId) {
			case ScreenIDs.ABOUT :
				screen = new AboutScreen();
				break;
			case ScreenIDs.WORD :
				screen = noteScreen;
				break;
			case ScreenIDs.PHRASE :
				screen = noteScreen;
				break;
			case ScreenIDs.VERB :
				screen = noteScreen;
				break;
			case ScreenIDs.TEST :
				screen = testScreen;
				break;
			case ScreenIDs.SEARCH :
				screen = new TemplateScreen();
				break;
			case ScreenIDs.SETTINGS :
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
