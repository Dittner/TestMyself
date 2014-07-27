package dittner.testmyself.view.screen.about {
import dittner.testmyself.message.ServiceMsg;
import dittner.testmyself.message.ViewMsg;
import dittner.testmyself.model.vo.DataBaseInfoVo;

import mvcexpress.mvc.Mediator;

public class AboutMediator extends Mediator {

	[Inject]
	public var view:AboutView;

	override protected function onRegister():void {
		sendMessage(ViewMsg.LOCK_VIEWS);
		addHandler(ServiceMsg.ON_DATA_BASE_INFO, showDataBaseInfo);
		sendMessage(ServiceMsg.GET_DATA_BASE_INFO);
	}

	private function showDataBaseInfo(dataBaseInfo:DataBaseInfoVo):void {
		view.dataBaseInfo = dataBaseInfo;
		sendMessage(ViewMsg.UNLOCK_VIEWS);
	}

	override protected function onRemove():void {
		view.dataBaseInfo = null;
	}
}
}