package dittner.testmyself.model.phrases {
import dittner.testmyself.message.PhrasesMsg;

import flash.events.Event;

import mvcexpress.mvc.Proxy;

public class PhrasesModel extends Proxy {
	public function PhrasesModel() {}

	override protected function onRegister():void {
		trace("PhrasesProxy registered");
	}

	public function getPhrases():void {
		//load phrases methods;
	}

	public var phrases:Array;
	private function loaderCompleteHandler(e:Event):void {
		phrases = [];
		sendMessage(PhrasesMsg.PHRASES_LOADED, phrases);
	}

	override protected function onRemove():void {
		trace("   PhrasesProxy removed");
	}
}
}
