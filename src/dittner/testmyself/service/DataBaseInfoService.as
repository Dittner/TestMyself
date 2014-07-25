package dittner.testmyself.service {
import dittner.testmyself.message.DataBaseInfoMsg;
import dittner.testmyself.model.model_internal;
import dittner.testmyself.model.vo.DataBaseInfoVo;
import dittner.testmyself.utils.pendingInvoke.doLaterInMSec;

import mvcexpress.mvc.Proxy;

use namespace model_internal;

public class DataBaseInfoService extends Proxy {
	public function DataBaseInfoService() {
		super();
	}

	public function load():void {
		doLaterInMSec(sendFakeData, 2000);
	}

	private function sendFakeData():void {
		var info:DataBaseInfoVo = new DataBaseInfoVo();
		info._wodsNum = 1456;
		info._phrasesNum = 567;
		info._strongVerbsNum = 143;
		info._examplesNum = 3456;
		info._audioRecordsNum = 12456;
		sendMessage(DataBaseInfoMsg.ON_DATA_BASE_INFO, info);
	}

	override protected function onRegister():void {}

	override protected function onRemove():void {}
}
}
