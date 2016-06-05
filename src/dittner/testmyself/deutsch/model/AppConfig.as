package dittner.testmyself.deutsch.model {
import flash.filesystem.File;
import flash.system.Capabilities;

public class AppConfig {

	public static const APP_NAME:String = "TestMyself";
	public static const LANGUAGE_NAME:String = "deutsch";

	public static const MAX_TEXT_LENGTH:uint = 5000;
	public static const MAX_THEME_NAME_LENGTH:uint = 100;
	public static const MAX_WORD_LENGTH:uint = 100;

	public static function get dbRootPath():String {
		return APP_NAME + File.separator + LANGUAGE_NAME + File.separator;
	}

	public static function get applicationDBPath():String {
		return "dataBase" + File.separator + APP_NAME + File.separator;
	}

	public static function get isWIN():Boolean {
		return Capabilities.os.toLowerCase().indexOf("windows") >= 0
	}

	public static function get isMAC():Boolean {
		return Capabilities.os.toLowerCase().indexOf("mac") >= 0
	}

	public static function get isDesktop():Boolean {
		return isWIN || isMAC;
	}

}
}
