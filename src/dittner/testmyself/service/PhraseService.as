package dittner.testmyself.service {
import dittner.testmyself.model.model_internal;
import dittner.testmyself.model.vo.ThemeVo;
import dittner.testmyself.utils.pendingInvoke.doLaterInMSec;
import dittner.testmyself.view.common.mediator.IOperationMessage;

import mvcexpress.mvc.Proxy;

use namespace model_internal;

public class PhraseService extends Proxy {

	public function PhraseService() {
		super();
	}

	private var loadThemesOperations:Vector.<IOperationMessage> = new <IOperationMessage>[];
	private var isThemesLoading:Boolean = false;

	public function loadThemes(op:IOperationMessage):void {
		loadThemesOperations.push(op);
		if (!isThemesLoading) {
			isThemesLoading = true;
			doLaterInMSec(sendFakeData, 500);
		}
	}

	private function sendFakeData():void {
		isThemesLoading = false;

		var themes:Array = [];
		var vo:ThemeVo;

		vo = new ThemeVo();
		vo.id = "1";
		vo.name = "Heidegger Zitaten";
		themes.push(vo);

		vo = new ThemeVo();
		vo.id = "2";
		vo.name = "2014";
		themes.push(vo);

		vo = new ThemeVo();
		vo.id = "3";
		vo.name = "favorite";
		themes.push(vo);

		vo = new ThemeVo();
		vo.id = "4";
		vo.name = "Large text";
		themes.push(vo);

		for each(var op:IOperationMessage in loadThemesOperations) {
			op.complete(themes);
		}
		loadThemesOperations.length = 0;
	}

	override protected function onRegister():void {}

	override protected function onRemove():void {}
}
}
