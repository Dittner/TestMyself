package de.dittner.testmyself.model {
import flash.desktop.NativeApplication;
import flash.display.Stage;
import flash.filesystem.File;
import flash.system.Capabilities;

public class Device {

	public static const APP_NAME:String = "TestMyself";
	public static const TEMP_APP_NAME:String = "TestMyself_temp";
	public static const NOTE_DB_NAME:String = "note.db";
	public static const ENGLISH_DIC_DB_NAME:String = "EN_RU_DIC.db";
	public static const AUDIO_DB_NAME:String = "audio.db";
	public static const SQL_TILE_STORAGE_DB_NAME:String = "tileStorage.db";

	public static const MAX_TEXT_LENGTH:uint = 5000;
	public static const MAX_TAG_NAME_LENGTH:uint = 100;
	public static const MAX_WORD_LENGTH:uint = 100;

	private static var _stage:Stage;
	public static function get stage():Stage {
		return _stage;
	}

	public static function init(stage:Stage):void {
		_stage = stage;
		_factor = isDesktop ? 1 : Math.min(stage.fullScreenWidth, stage.fullScreenHeight) / 768;
		_factor = Math.ceil((_factor * 10)) / 10;

		var appDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
		var ns:Namespace = appDescriptor.namespace();
		_appVersion = appDescriptor.ns::versionNumber;
	}

	public static function get isPortraitOrientation():Boolean {
		return height >= width;
	}

	public static function get verticalPadding():Number {
		return isIOS ? isQuadHD ? 40 : 20 : 0;
	}

	public static function get isQuadHD():Boolean {
		return stage.stageWidth >= 1242;
	}

	public static function get width():Number {
		return stage.stageWidth;
	}

	public static function get height():Number {
		return stage.stageHeight - verticalPadding;
	}

	private static var _factor:Number;
	public static function get factor():Number {
		return _factor;
	}

	public static function get isIOS():Boolean {
		return Capabilities.os.toLowerCase().indexOf("iphone") >= 0;
	}

	public static function get isAND():Boolean {
		return Capabilities.os.toLowerCase().indexOf("android") >= 0 || isLinux;
	}

	public static function get isLinux():Boolean {
		return Capabilities.os.toLowerCase().indexOf("linux") >= 0;
	}

	public static function get dbRootPath():String {
		return APP_NAME + File.separator;
	}

	public static function get noteDBPath():String {
		return APP_NAME + File.separator + NOTE_DB_NAME;
	}

	public static function get englishDicDBPath():String {
		return APP_NAME + File.separator + ENGLISH_DIC_DB_NAME;
	}

	public static function get tileDBPath():String {
		return APP_NAME + File.separator + SQL_TILE_STORAGE_DB_NAME;
	}

	public static function get audioDBPath():String {
		return APP_NAME + File.separator + AUDIO_DB_NAME;
	}

	public static function get dbTempPath():String {
		return TEMP_APP_NAME + File.separator;
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

	private static var _appVersion:String = "";
	public static function get appVersion():String {
		return _appVersion;
	}

}
}
