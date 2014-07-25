package dittner.testmyself.view.about {
import dittner.testmyself.message.DataBaseInfoMsg;
import dittner.testmyself.message.ViewMsg;
import dittner.testmyself.model.vo.DataBaseInfoVo;

import mvcexpress.mvc.Mediator;

public class AboutMediator extends Mediator {

	[Inject]
	public var view:AboutView;

	override protected function onRegister():void {
		sendMessage(ViewMsg.HIDE_VIEW_LIST);
		addHandler(DataBaseInfoMsg.ON_DATA_BASE_INFO, showDataBaseInfo);
		sendMessage(DataBaseInfoMsg.GET_DATA_BASE_INFO);
	}

	private function showDataBaseInfo(dataBaseInfo:DataBaseInfoVo):void {
		view.dataBaseInfo = dataBaseInfo;
		sendMessage(ViewMsg.SHOW_VIEW_LIST);
	}

	override protected function onRemove():void {
		view.dataBaseInfo = null;
	}
}
}