package dittner.testmyself.model {
import flash.filesystem.File;

public class AppConfig {

	public static const APP_NAME:String = "TestMyself";
	public static const LANGUAGE_NAME:String = "deutsch";

	public static const PHRASE_DB_NAME:String = "phrase.db";
	public static const WORD_DB_NAME:String = "word.db";
	public static const VERB_DB_NAME:String = "verb.db";

	public static function get dbRootPath():String {
		return APP_NAME + File.separator + LANGUAGE_NAME + File.separator;
	}
}
}
