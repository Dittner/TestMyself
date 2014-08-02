package dittner.testmyself.service.helpers.toolFactory {
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.EventDispatcher;

public class Tool extends EventDispatcher {
	public static const ACTIVE_CHANGED_EVENT:String = "activeChanged";
	public static const NULL:Tool = new Tool(ToolId.NULL, "", null);

	public function Tool(id:uint, description:String, icon:BitmapData) {
		_id = id;
		_description = description;
		_icon = icon;
	}

	private var _id:uint;
	public function get id():uint {return _id;}

	private var _description:String = "";
	public function get description():String {return _description;}

	private var _icon:BitmapData;
	public function get icon():BitmapData {return _icon;}

	//--------------------------------------
	//  active
	//--------------------------------------
	private var _active:Boolean = false;
	[Bindable("activeChanged")]
	public function get active():Boolean {return _active;}
	public function set active(value:Boolean):void {
		if (_active != value) {
			_active = value;
			dispatchEvent(new Event("activeChanged"));
		}
	}
}
}