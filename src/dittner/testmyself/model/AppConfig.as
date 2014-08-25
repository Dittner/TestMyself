package dittner.testmyself.model {
import flash.filesystem.File;

public class AppConfig {

	public static const APP_NAME:String = "TestMyself";
	public static const LANGUAGE_NAME:String = "deutsch";

	public static const PHRASE_DB_NAME:String = "phrase";
	public static const WORD_DB_NAME:String = "word";
	public static const VERB_DB_NAME:String = "verb";

	public static const MAX_PHRASE_LENGTH:uint = 5000;
	public static const MAX_THEME_LENGTH:uint = 100;

	public static function get dbRootPath():String {
		return APP_NAME + File.separator + LANGUAGE_NAME + File.separator;
	}
}
}
