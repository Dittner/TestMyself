package dittner.testmyself.deutsch.model {
import flash.filesystem.File;

public class AppConfig {

	public static const APP_NAME:String = "TestMyself";
	public static const LANGUAGE_NAME:String = "deutsch";

	public static const MAX_PHRASE_TEXT_LENGTH:uint = 5000;
	public static const MAX_THEME_NAME_LENGTH:uint = 100;
	public static const MAX_WORD_LENGTH:uint = 100;

	public static function get dbRootPath():String {
		return APP_NAME + File.separator + LANGUAGE_NAME + File.separator;
	}
}
}
