package dittner.testmyself.service.helpers.viewFactory {
import dittner.testmyself.view.core.ViewBase;
import dittner.testmyself.view.screen.about.AboutView;
import dittner.testmyself.view.common.renderer.SeparatorVo;
import dittner.testmyself.view.screen.phrases.PhrasesView;
import dittner.testmyself.view.template.TemplateView;
import dittner.testmyself.view.utils.AppColors;
import dittner.testmyself.view.core.view_internal;

import flash.display.BitmapData;

import mvcexpress.mvc.Proxy;

use namespace view_internal;

public class ViewFactory extends Proxy implements IViewFactory {
	[Embed(source='/assets/view/about.png')]
	protected static const AboutIconClass:Class;

	[Embed(source='/assets/view/word.png')]
	protected static const WordsIconClass:Class;

	[Embed(source='/assets/view/phrases.png')]
	protected static const PhrasesIconClass:Class;

	[Embed(source='/assets/view/verbs.png')]
	protected static const VerbsIconClass:Class;

	[Embed(source='/assets/view/tests.png')]
	protected static const TestsIconClass:Class;

	[Embed(source='/assets/view/search.png')]
	protected static const SearchIconClass:Class;

	[Embed(source='/assets/view/settings.png')]
	protected static const SettingsIconClass:Class;

	public function ViewFactory():void {
		createViewInfos();
	}

	private var viewInfosHash:Object;
	private var _viewInfos:Array;
	public function get viewInfos():Array {
		return _viewInfos;
	}

	private function createViewInfos():void {
		_viewInfos = [];
		viewInfosHash = {};
		var info:ViewInfo;

		info = new ViewInfo(ViewId.ABOUT, "", "Главный экран с описанием программы и базы данных", getIcon(ViewId.ABOUT));
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;

		_viewInfos.push(createViewSeparator());

		info = new ViewInfo(ViewId.WORD, "Список слов", "Экран со списком слов", getIcon(ViewId.WORD));
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;

		info = new ViewInfo(ViewId.PHRASE, "Список фраз и предложений", "Экран со списком фраз и предложений", getIcon(ViewId.PHRASE));
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;

		info = new ViewInfo(ViewId.VERB, "Таблица сильных глаголов", "Экран с таблицей сильных глаголов", getIcon(ViewId.VERB));
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;

		info = new ViewInfo(ViewId.TEST, "Тестирование", "Экран тестирования", getIcon(ViewId.TEST));
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;

		_viewInfos.push(createViewSeparator());

		info = new ViewInfo(ViewId.SEARCH, "Поиск", "Экран поиска слов в базе данных", getIcon(ViewId.SEARCH));
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;

		info = new ViewInfo(ViewId.SETTINGS, "Настройки", "Экран с настройками программы", getIcon(ViewId.SETTINGS));
		_viewInfos.push(info);
		viewInfosHash[info.id] = info;
	}

	private function createViewSeparator():SeparatorVo {
		return new SeparatorVo(0, 50, AppColors.VIEW_LIST_BG, 1);
	}

	private function getIcon(viewId:uint):BitmapData {
		var bitmapData:BitmapData = new BitmapData(50, 50, true, 0x00ffffff);
		var IconClass:Class;
		switch (viewId) {
			case ViewId.ABOUT :
				IconClass = AboutIconClass;
				break;
			case ViewId.WORD :
				IconClass = WordsIconClass;
				break;
			case ViewId.PHRASE :
				IconClass = PhrasesIconClass;
				break;
			case ViewId.VERB :
				IconClass = VerbsIconClass;
				break;
			case ViewId.TEST :
				IconClass = TestsIconClass;
				break;
			case ViewId.SEARCH :
				IconClass = SearchIconClass;
				break;
			case ViewId.SETTINGS :
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
			case ViewId.ABOUT :
				view = new AboutView();
				break;
			case ViewId.WORD :
				view = new TemplateView();
				break;
			case ViewId.PHRASE :
				view = new PhrasesView();
				break;
			case ViewId.VERB :
				view = new TemplateView();
				break;
			case ViewId.TEST :
				view = new TemplateView();
				break;
			case ViewId.SEARCH :
				view = new TemplateView();
				break;
			case ViewId.SETTINGS :
				view = new TemplateView();
				break;
			default :
				throw new Error("Unknown view ID:" + viewId);
		}

		view._info = viewInfosHash[viewId];
		return view;
	}

	public function generateFirstView():ViewBase {
		return generate(ViewId.ABOUT);
	}

}
}
