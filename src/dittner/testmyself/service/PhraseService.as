package dittner.testmyself.service {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.model_internal;
import dittner.testmyself.model.vo.ThemeVo;
import dittner.testmyself.utils.pendingInvoke.doLaterInMSec;

import mvcexpress.mvc.Proxy;

use namespace model_internal;

public class PhraseService extends Proxy {

	public function PhraseService() {
		super();
	}

	public function loadThemes():void {
		doLaterInMSec(sendFakeData, 500);
	}

	private function sendFakeData():void {
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

		sendMessage(PhraseMsg.ON_THEMES, themes);
	}

	override protected function onRegister():void {}

	override protected function onRemove():void {}
}
}
