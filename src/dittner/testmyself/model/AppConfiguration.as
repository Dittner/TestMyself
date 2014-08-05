package dittner.testmyself.model {
import flash.filesystem.File;

public class AppConfiguration {

	public static const APP_NAME:String = "TestMyself";
	public static const LANGUAGE_NAME:String = "deutsch";

	public static const DB_ROOT_PATH:String = APP_NAME + SEP + LANGUAGE_NAME + SEP;
	public static const SEP:String = File.separator;

	public static const PHRASE_DB_NAME:String = "phrase.db";
	public static const PHRASE_THEME_DB_NAME:String = "phraseTheme.db";
	public static const PHRASE_AUDIO_DB_NAME:String = "phraseAudio.db";
}
}
