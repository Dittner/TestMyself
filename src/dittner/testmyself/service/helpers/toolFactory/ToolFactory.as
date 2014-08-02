package dittner.testmyself.service.helpers.toolFactory {
import flash.display.BitmapData;

import mvcexpress.mvc.Proxy;

public class ToolFactory extends Proxy implements IToolFactory {
	[Embed(source='/assets/tools/add.png')]
	private static const AddIconClass:Class;

	[Embed(source='/assets/tools/edit.png')]
	private static const EditIconClass:Class;

	[Embed(source='/assets/tools/recycle_bin.png')]
	private static const DeleteIconClass:Class;

	[Embed(source='/assets/tools/trans_inversion.png')]
	private static const TransInversionIconClass:Class;

	[Embed(source='/assets/tools/filter.png')]
	private static const FilterIconClass:Class;

	public function ToolFactory() {
		super();
		createTools();
	}

	private var toolHash:Object;

	private function createTools():void {
		toolHash = {};
		var info:Tool;

		info = new Tool(ToolId.ADD, "Добавить новый элемент", getIcon(ToolId.ADD));
		toolHash[info.id] = info;

		info = new Tool(ToolId.EDIT, "Редактировать выбранный элемент", getIcon(ToolId.EDIT));
		toolHash[info.id] = info;

		info = new Tool(ToolId.REMOVE, "Удалить выбранный элемент", getIcon(ToolId.REMOVE));
		toolHash[info.id] = info;

		info = new Tool(ToolId.TRANS_INVERSION, "Инвертировать перевод", getIcon(ToolId.TRANS_INVERSION));
		toolHash[info.id] = info;

		info = new Tool(ToolId.FILTER, "Фильтровать по темам", getIcon(ToolId.FILTER));
		toolHash[info.id] = info;
	}

	private function getIcon(toolId:uint):BitmapData {
		var bitmapData:BitmapData = new BitmapData(50, 35, true, 0x00ffffff);
		var IconClass:Class;
		switch (toolId) {
			case ToolId.ADD :
				IconClass = AddIconClass;
				break;
			case ToolId.EDIT :
				IconClass = EditIconClass;
				break;
			case ToolId.REMOVE :
				IconClass = DeleteIconClass;
				break;
			case ToolId.TRANS_INVERSION :
				IconClass = TransInversionIconClass;
				break;
			case ToolId.FILTER :
				IconClass = FilterIconClass;
				break;
			default :
				throw new Error("Unknown tool ID:" + toolId);
		}
		bitmapData.draw(new IconClass());
		return bitmapData;
	}

	public function generate(toolIds:Array):Array {
		var tools:Array = [];
		for each(var toolId:uint in toolIds) {
			if (!toolHash[toolId]) throw new Error("Unknown tool id:" + toolId + ", can not generate tool!");
			else tools.push(toolHash[toolId]);
		}
		return tools;
	}
}
}
