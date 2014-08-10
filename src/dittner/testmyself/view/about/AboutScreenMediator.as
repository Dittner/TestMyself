package dittner.testmyself.view.about {
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.message.ServiceMsg;
import dittner.testmyself.model.common.DataBaseInfoVo;

import mvcexpress.mvc.Mediator;

public class AboutScreenMediator extends Mediator {

	[Inject]
	public var view:AboutScreen;

	override protected function onRegister():void {
		sendMessage(ScreenMsg.LOCK_UI);
		addHandler(ServiceMsg.ON_DATA_BASE_INFO, showDataBaseInfo);
		sendMessage(ServiceMsg.GET_DATA_BASE_INFO);
	}

	private function showDataBaseInfo(dataBaseInfo:DataBaseInfoVo):void {
		view.dataBaseInfo = dataBaseInfo;
		sendMessage(ScreenMsg.UNLOCK_UI);
	}

	override protected function onRemove():void {
		view.dataBaseInfo = null;
	}
}
}