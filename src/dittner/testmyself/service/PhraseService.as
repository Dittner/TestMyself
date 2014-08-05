package dittner.testmyself.service {
import dittner.testmyself.model.model_internal;
import dittner.testmyself.model.phrase.PhraseVo;
import dittner.testmyself.model.theme.ThemeVo;
import dittner.testmyself.utils.pendingInvoke.doLaterInMSec;
import dittner.testmyself.view.common.mediator.IOperationMessage;

import mvcexpress.mvc.Proxy;

use namespace model_internal;

public class PhraseService extends Proxy {

	public function PhraseService() {
		super();
	}

	private var loadThemesOperations:Vector.<IOperationMessage> = new <IOperationMessage>[];
	private var loadPhrasesOperations:Vector.<IOperationMessage> = new <IOperationMessage>[];
	private var isThemesLoading:Boolean = false;
	private var isPhrasesLoading:Boolean = false;

	public function loadThemes(op:IOperationMessage):void {
		loadThemesOperations.push(op);
		if (!isThemesLoading) {
			isThemesLoading = true;
			doLaterInMSec(sendFakeThemes, 500);
		}
	}

	public function loadPhrases(op:IOperationMessage):void {
		loadPhrasesOperations.push(op);
		if (!isPhrasesLoading) {
			isPhrasesLoading = true;
			doLaterInMSec(sendFakePhrases, 500);
		}
	}

	private function sendFakeThemes():void {
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

	private function sendFakePhrases():void {
		isPhrasesLoading = false;

		var phrases:Array = [];
		var vo:PhraseVo;

		vo = new PhraseVo();
		vo.id = "1";
		vo.origin = "Wir kommen nie zu Gedanken. Sie kommen zu uns. (Heidegger)";
		vo.translation = "Мы никогда не приходим к мыслям. Они приходят к нам.";
		phrases.push(vo);

		vo = new PhraseVo();
		vo.id = "2";
		vo.origin = "Wer fremde Sprache nicht kennt, weiss nichts von seiner eigenen. (Goethe)";
		vo.translation = "Тот, кому чужды иностранные языки – ничего не смыслит в собственном языке.";
		phrases.push(vo);

		vo = new PhraseVo();
		vo.id = "3";
		vo.origin = "Die Wahrheit bedarf nicht viele Worte, die Luge kann nie genug haben…";
		vo.translation = "Истина не многословна, для лжи слов всегда недостаточно…";
		phrases.push(vo);

		vo = new PhraseVo();
		vo.id = "4";
		vo.origin = "Was mich nicht umbringt, macht mich stärker. (Nietzsche)";
		vo.translation = "Что меня не убивает - делает меня сильнее.";
		phrases.push(vo);

		vo = new PhraseVo();
		vo.id = "5";
		vo.origin = "Entweder kommst du heute eine Stufe höher, oder du sammelst deine Kräfte, damit du morgen höher steigst. (Nietzsche)";
		vo.translation = "Либо вы поднимитесь вверх на одну ступень сегодня, или соберитесь с силами, чтобы подняться на эту ступень завтра";
		phrases.push(vo);

		for each(var op:IOperationMessage in loadPhrasesOperations) {
			op.complete(phrases);
		}
		loadPhrasesOperations.length = 0;
	}

	override protected function onRegister():void {}

	override protected function onRemove():void {}
}
}
