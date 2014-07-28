package dittner.testmyself.service.helpers.screenFactory {
import dittner.testmyself.view.common.renderer.SeparatorVo;
import dittner.testmyself.view.common.screen.ScreenBase;
import dittner.testmyself.view.common.screen.screen_internal;
import dittner.testmyself.view.about.AboutView;
import dittner.testmyself.view.phrase.PhraseView;
import dittner.testmyself.view.template.TemplateView;
import dittner.testmyself.view.common.utils.AppColors;

import flash.display.BitmapData;

import mvcexpress.mvc.Proxy;

use namespace screen_internal;

public class ScreenFactory extends Proxy implements IScreenFactory {
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
	private var _screens:Array;
	public function get screens():Array {
		return _screens;
	}

	private function createScreenInfos():void {
		_screens = [];
		screensHash = {};
		var info:ScreenInfo;

		info = new ScreenInfo(ScreenId.ABOUT, "", "Главный экран с описанием программы и базы данных", getIcon(ScreenId.ABOUT));
		_screens.push(info);
		screensHash[info.id] = info;

		_screens.push(createScreenItemSeparator());

		info = new ScreenInfo(ScreenId.WORD, "Список слов", "Экран со списком слов", getIcon(ScreenId.WORD));
		_screens.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenId.PHRASE, "Список фраз и предложений", "Экран со списком фраз и предложений", getIcon(ScreenId.PHRASE));
		_screens.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenId.VERB, "Таблица сильных глаголов", "Экран с таблицей сильных глаголов", getIcon(ScreenId.VERB));
		_screens.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenId.TEST, "Тестирование", "Экран тестирования", getIcon(ScreenId.TEST));
		_screens.push(info);
		screensHash[info.id] = info;

		_screens.push(createScreenItemSeparator());

		info = new ScreenInfo(ScreenId.SEARCH, "Поиск", "Экран поиска слов в базе данных", getIcon(ScreenId.SEARCH));
		_screens.push(info);
		screensHash[info.id] = info;

		info = new ScreenInfo(ScreenId.SETTINGS, "Настройки", "Экран с настройками программы", getIcon(ScreenId.SETTINGS));
		_screens.push(info);
		screensHash[info.id] = info;
	}

	private function createScreenItemSeparator():SeparatorVo {
		return new SeparatorVo(0, 50, AppColors.SCREEN_LIST_BG, 1);
	}

	private function getIcon(screenId:uint):BitmapData {
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

	public function generate(screenId:uint):ScreenBase {
		var screen:ScreenBase;
		switch (screenId) {
			case ScreenId.ABOUT :
				screen = new AboutView();
				break;
			case ScreenId.WORD :
				screen = new TemplateView();
				break;
			case ScreenId.PHRASE :
				screen = new PhraseView();
				break;
			case ScreenId.VERB :
				screen = new TemplateView();
				break;
			case ScreenId.TEST :
				screen = new TemplateView();
				break;
			case ScreenId.SEARCH :
				screen = new TemplateView();
				break;
			case ScreenId.SETTINGS :
				screen = new TemplateView();
				break;
			default :
				throw new Error("Unknown screen ID:" + screenId);
		}

		screen._info = screensHash[screenId];
		return screen;
	}

	public function generateFirstScreen():ScreenBase {
		return generate(ScreenId.ABOUT);
	}

}
}