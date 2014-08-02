package dittner.testmyself.model.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.service.helpers.toolFactory.IToolFactory;
import dittner.testmyself.service.helpers.toolFactory.Tool;
import dittner.testmyself.service.helpers.toolFactory.ToolId;

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
		ToolId.ADD, ToolId.EDIT, ToolId.REMOVE, ToolId.TRANS_INVERSION, ToolId.FILTER];

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
	private var _selectedPhrase:PhraseVo;
	public function get selectedPhrase():PhraseVo {return _selectedPhrase;}
	public function set selectedPhrase(value:PhraseVo):void {
		if (_selectedPhrase != value) {
			_selectedPhrase = value;
			sendMessage(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, selectedPhrase);
		}
	}

	//--------------------------------------
	//  selectedTool
	//--------------------------------------
	private var _selectedTool:Tool = Tool.NULL;
	public function get selectedTool():Tool {return _selectedTool;}
	public function set selectedTool(value:Tool):void {
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

	public function clear():void {
		_selectedTool = Tool.NULL;
		_selectedPhrase = null;
	}

	override protected function onRegister():void {
		trace("PhraseModel onRegister");
	}
	override protected function onRemove():void {
		trace("PhraseModel onRemove");
	}

}
}
