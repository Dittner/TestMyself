package dittner.testmyself.service.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.message.PhraseMsg;

import mvcexpress.mvc.Proxy;

public class PhraseService extends Proxy {

	public function PhraseService() {
		super();
	}

	public var sqlRunner:SQLRunner;
	public function get isDataBaseCreated():Boolean {return sqlRunner != null;}

	override protected function onRegister():void {
		sendMessage(PhraseMsg.CREATE_DB);
	}

	override protected function onRemove():void {
		sqlRunner.close(resultHandler);
	}

	private function resultHandler():void {
		trace("resultHandler");
	}

}
}
