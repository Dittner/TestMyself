package dittner.testmyself.model.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.vo.LanguageUnitVo;
import dittner.testmyself.service.helpers.toolFactory.IToolFactory;
import dittner.testmyself.service.helpers.toolFactory.ToolId;
import dittner.testmyself.service.helpers.toolFactory.ToolInfo;

import mvcexpress.mvc.Proxy;

public class PhraseModel extends Proxy {

	[Inject]
	public var toolFactory:IToolFactory;

	//----------------------------------------------------------------------------------------------
	//
	//  Const
	//
	//----------------------------------------------------------------------------------------------

	private static const TOOL_IDS:Array = [
		ToolId.ADD, ToolId.EDIT, ToolId.DELETE, ToolId.TRANS_INVERSION, ToolId.FILTER];

	//----------------------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//----------------------------------------------------------------------------------------------

	public function PhraseModel():void {
		super();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------


	//--------------------------------------
	//  selectedPhrase
	//--------------------------------------
	private var _selectedPhrase:LanguageUnitVo;
	public function get selectedPhrase():LanguageUnitVo {return _selectedPhrase;}
	public function set selectedPhrase(value:LanguageUnitVo):void {
		if (_selectedPhrase != value) {
			_selectedPhrase = value;
			sendMessage(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, selectedPhrase);
		}
	}

	//--------------------------------------
	//  selectedTool
	//--------------------------------------
	private var _selectedTool:ToolInfo;
	[Bindable("selectedToolChanged")]
	public function get selectedTool():ToolInfo {return _selectedTool;}
	public function set selectedTool(value:ToolInfo):void {
		if (_selectedTool != value) {
			_selectedTool = value;
			sendMessage(PhraseMsg.TOOL_SELECTED_NOTIFICATION, selectedTool);
		}
	}

	//--------------------------------------
	//  tools
	//--------------------------------------
	public function getTools():Array {return toolFactory.generate(TOOL_IDS);}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function onRegister():void {
		trace("PhraseModel onRegister");
	}
	override protected function onRemove():void {
		trace("PhraseModel onRemove");
	}

}
}
