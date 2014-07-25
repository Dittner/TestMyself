package dittner.testmyself.model {
import dittner.testmyself.view.about.AboutView;
import dittner.testmyself.view.common.renderer.SeparatorVo;
import dittner.testmyself.view.core.IViewFactory;
import dittner.testmyself.view.core.ViewBase;
import dittner.testmyself.view.core.ViewInfo;
import dittner.testmyself.view.core.view_internal;
import dittner.testmyself.view.template.TemplateView;
import dittner.testmyself.view.utils.AppColors;

import flash.display.BitmapData;

import mvcexpress.mvc.Proxy;

use namespace view_internal;

public class ViewFactory extends Proxy implements IViewFactory {
	[Embed(source='/assets/deutsch/view/about.png')]
	protected static var AboutIconClass:Class;

	[Embed(source='/assets/deutsch/view/word.png')]
	protected static var WordsIconClass:Class;

	[Embed(source='/assets/deutsch/view/phrases.png')]
	protected static var PhrasesIconClass:Class;

	[Embed(source='/assets/deutsch/view/verbs.png')]
	protected static var VerbsIconClass:Class;

	[Embed(source='/assets/deutsch/view/tests.png')]
	protected static var TestsIconClass:Class;

	[Embed(source='/assets/deutsch/view/search.png')]
	protected static var SearchIconClass:Class;

	[Embed(source='/assets/deutsch/view/settings.png')]
	protected static var SettingsIconClass:Class;

	private static const ABOUT_ID:int = 0;
	private static const WORD_ID:int = 1;
	private static const PHRASE_ID:int = 2;
	private static const VERB_ID:int = 3;
	private static const TEST_ID:int = 4;
	private static const SEARCH_ID:int = 5;
	private static const SETTINGS_ID:int = 6;

	private var viewInfosHash:Object;

	public function ViewFactory():void {
		createViewInfos();
	}

	private function createViewInfos():void {
		_viewInfos = [];
		viewInfosHash = {};
		var info:ViewInfo;

		info = new ViewInfo();
		info._id = ABOUT_ID;
		info._title = "";
		info._description = "Главный экран с описанием программы и базы данных";
		info._icon = getIcon(info.id);
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;

		_viewInfos.push(createViewSeparator());

		info = new ViewInfo();
		info._id = WORD_ID;
		info._title = "Список слов";
		info._description = "Экран со списком слов";
		info._icon = getIcon(info.id);
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;

		info = new ViewInfo();
		info._id = PHRASE_ID;
		info._title = "Список фраз и предложений";
		info._description = "Экран со списком фраз и предложений";
		info._icon = getIcon(info.id);
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;

		info = new ViewInfo();
		info._id = VERB_ID;
		info._title = "Таблица сильных глаголов";
		info._description = "Экран с таблицей сильных глаголов";
		info._icon = getIcon(info.id);
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;

		info = new ViewInfo();
		info._id = TEST_ID;
		info._title = "Тестирование";
		info._description = "Экран тестирования";
		info._icon = getIcon(info.id);
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;

		_viewInfos.push(createViewSeparator());

		info = new ViewInfo();
		info._id = SEARCH_ID;
		info._title = "Поиск";
		info._description = "Экран поиска слов в базе данных";
		info._icon = getIcon(info.id);
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;

		info = new ViewInfo();
		info._id = SETTINGS_ID;
		info._title = "Настройки";
		info._description = "Экран с настройками программы";
		info._icon = getIcon(info.id);
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;
	}

	private function createViewSeparator():SeparatorVo {
		return new SeparatorVo(0, 5, AppColors.BG, 1);
	}

	private function getIcon(viewId:uint):BitmapData {
		var bitmapData:BitmapData = new BitmapData(50, 50, true, 0x00ffffff);
		var IconClass:Class;
		switch (viewId) {
			case ABOUT_ID :
				IconClass = AboutIconClass;
				break;
			case WORD_ID :
				IconClass = WordsIconClass;
				break;
			case PHRASE_ID :
				IconClass = PhrasesIconClass;
				break;
			case VERB_ID :
				IconClass = VerbsIconClass;
				break;
			case TEST_ID :
				IconClass = TestsIconClass;
				break;
			case SEARCH_ID :
				IconClass = SearchIconClass;
				break;
			case SETTINGS_ID :
				IconClass = SettingsIconClass;
				break;
			default :
				throw new Error("Unknown view ID:" + viewId);
		}
		bitmapData.draw(new IconClass());
		return bitmapData;
	}

	public function generate(viewId:uint):ViewBase {
		var view:ViewBase;
		switch (viewId) {
			case ABOUT_ID :
				view = new AboutView();
				break;
			case WORD_ID :
				view = new TemplateView();
				break;
			case PHRASE_ID :
				view = new TemplateView();
				break;
			case VERB_ID :
				view = new TemplateView();
				break;
			case TEST_ID :
				view = new TemplateView();
				break;
			case SEARCH_ID :
				view = new TemplateView();
				break;
			case SETTINGS_ID :
				view = new TemplateView();
				break;
			default :
				throw new Error("Unknown view ID:" + viewId);
		}

		view._info = viewInfosHash[viewId];
		return view;
	}

	public function generateFirstView():ViewBase {
		return generate(ABOUT_ID);
	}

	private var _viewInfos:Array;
	public function get viewInfos():Array {
		return _viewInfos;
	}
}
}
