package dittner.testmyself.model.language {
import mvcexpress.mvc.Proxy;

public class Language extends Proxy implements ILanguage {

	public static const DE:String = "de";
	public static const EN:String = "en";

	public function Language():void {
		super();
	}

	//--------------------------------------
	//  name
	//--------------------------------------
	private var _name:String;
	public function get name():String {return _name;}
	public function set name(value:String):void {
		if (_name != value) {
			_name = value;
		}
	}

}
}
