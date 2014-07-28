package dittner.testmyself.view.screen.about {
import dittner.testmyself.message.ServiceMsg;
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.model.vo.DataBaseInfoVo;

import mvcexpress.mvc.Mediator;

public class AboutMediator extends Mediator {

	[Inject]
	public var view:AboutView;

	override protected function onRegister():void {
		sendMessage(ScreenMsg.LOCK_SCREEN_LIST);
		addHandler(ServiceMsg.ON_DATA_BASE_INFO, showDataBaseInfo);
		sendMessage(ServiceMsg.GET_DATA_BASE_INFO);
	}

	private function showDataBaseInfo(dataBaseInfo:DataBaseInfoVo):void {
		view.dataBaseInfo = dataBaseInfo;
		sendMessage(ScreenMsg.UNLOCK_SCREEN_LIST);
	}

	override protected function onRemove():void {
		view.dataBaseInfo = null;
	}
}
}