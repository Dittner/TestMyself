package dittner.testmyself.model.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.vo.LanguageUnitVo;
import dittner.testmyself.service.helpers.toolFactory.IToolFactory;
import dittner.testmyself.service.helpers.toolFactory.ToolId;

import mvcexpress.mvc.Proxy;

public class PhraseModel extends Proxy {

	[Inject]
	public var toolFactory:IToolFactory;

	private static const TOOL_INFOS:Array = [
		ToolId.ADD, ToolId.EDIT, ToolId.DELETE, ToolId.TRANS_INVERSION, ToolId.FILTER];

	public function PhraseModel():void {
		super();
	}

	//--------------------------------------
	//  selectedPhrase
	//--------------------------------------
	private var _selectedPhrase:LanguageUnitVo;
	public function get selectedPhrase():LanguageUnitVo {return _selectedPhrase;}
	public function set selectedPhrase(value:LanguageUnitVo):void {
		if (_selectedPhrase != value) {
			_selectedPhrase = value;
			sendMessage(PhraseMsg.PHRASE_SELECT, selectedPhrase);
		}
	}

	//--------------------------------------
	//  tools
	//--------------------------------------
	public function getTools():Array {return toolFactory.generateInfos(TOOL_INFOS);}

}
}
