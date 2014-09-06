package dittner.testmyself.deutsch.service.screenFactory {
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.deutsch.view.about.AboutScreen;
import dittner.testmyself.deutsch.view.common.renderer.SeparatorVo;
import dittner.testmyself.deutsch.view.common.screen.ScreenBase;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.note.NoteScreen;
import dittner.testmyself.deutsch.view.settings.SettingsScreen;
import dittner.testmyself.deutsch.view.template.TemplateScreen;

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

		info = new ScreenInfo(ScreenId.ABOUT, "", "Описание программы и базы данных", getIcon(ScreenId.ABOUT));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		_screenInfos.push(createScreenItemSeparator());

		info = new ScreenInfo(ScreenId.WORD, "СЛОВАРЬ СЛОВ", "Словарь слов", getIcon(ScreenId.WORD));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenId.PHRASE, "СЛОВАРЬ ФРАЗ И ПРЕДЛОЖЕНИЙ", "Словарь фраз и предложений", getIcon(ScreenId.PHRASE));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenId.VERB, "ТАБЛИЦА СИЛЬНЫХ ГЛАГОЛОВ", "Таблица сильных глаголов", getIcon(ScreenId.VERB));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenId.TEST, "ТЕСТИРОВАНИЕ", "Тестирование", getIcon(ScreenId.TEST));
		_screenInfos.push(info);
		screensHash[info.id] = info;

		_screenInfos.push(createScreenItemSeparator());

		/*info = new ScreenInfo(ScreenId.SEARCH, "ПОИСК", "Поиск в базе данных", getIcon(ScreenId.SEARCH));
		 _screenInfos.push(info);
		 screensHash[info.id] = info;*/

		info = new ScreenInfo(ScreenId.SETTINGS, "НАСТРОЙКИ", "Настройки программы", getIcon(ScreenId.SETTINGS));
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
			case ScreenId.ABOUT :
				IconClass = AboutIconClass;
				break;
			case ScreenId.WORD :
				IconClass = WordIconClass;
				break;
			case ScreenId.PHRASE :
				IconClass = PhraseIconClass;
				break;
			case ScreenId.VERB :
				IconClass = VerbIconClass;
				break;
			case ScreenId.TEST :
				IconClass = TestingIconClass;
				break;
			case ScreenId.SEARCH :
				IconClass = SearchIconClass;
				break;
			case ScreenId.SETTINGS :
				IconClass = SettingsIconClass;
				break;
			default :
				throw new Error("Unknown screen ID:" + screenId);
		}
		bitmapData.draw(new IconClass());
		return bitmapData;
	}

	private static var noteScreen:NoteScreen = new NoteScreen();
	public function createScreen(screenId:String):ScreenBase {
		var screen:ScreenBase;
		switch (screenId) {
			case ScreenId.ABOUT :
				screen = new AboutScreen();
				break;
			case ScreenId.WORD :
				screen = noteScreen;
				break;
			case ScreenId.PHRASE :
				screen = noteScreen;
				break;
			case ScreenId.VERB :
				screen = new TemplateScreen();
				break;
			case ScreenId.TEST :
				screen = new TemplateScreen();
				break;
			case ScreenId.SEARCH :
				screen = new TemplateScreen();
				break;
			case ScreenId.SETTINGS :
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
