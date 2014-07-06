package dittner.logging {
import com.junkbyte.console.Cc;
import com.junkbyte.console.Console;
import com.junkbyte.console.addons.htmlexport.ConsoleHtmlExportAddon;
import com.junkbyte.console.view.ChannelsPanel;
import com.junkbyte.console.view.ConsolePanel;
import com.junkbyte.console.view.GraphingPanel;

import flash.desktop.NativeApplication;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.system.Capabilities;
import flash.utils.getTimer;

import mx.core.mx_internal;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.logging.LogEvent;
import mx.logging.LogEventLevel;
import mx.logging.targets.LineFormattedTarget;

use namespace mx_internal;

public class ConsoleTarget extends LineFormattedTarget {

	private const PASSWORD:String = "";

	//----------------------------------------------------------------------------------------------
	//
	//  Constants
	//
	//----------------------------------------------------------------------------------------------
	private const PRIORITY_MAP:Object = {};
	private const excludeCategories:Array = ["com.coltware", "mx.rpc", "mx.messaging"];

	public function ConsoleTarget() {
		level = LogEventLevel.ALL;
		filters = ["*"];
		fillPriorityMap();
		Log.addTarget(this);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	private var logDate:Date = new Date();
	private var startTime:Number;
	private var initialTimer:int;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	private var _visibleOnStart:Boolean = false;
	public function get visibleOnStart():Boolean { return _visibleOnStart; }
	public function set visibleOnStart(value:Boolean):void {
		_visibleOnStart = value;
		if (Cc.instance) {
			Cc.visible = value;
		}
	}

	private var _parent:DisplayObjectContainer;
	public function get parent():DisplayObjectContainer { return _parent; 	}
	public function set parent(value:DisplayObjectContainer):void {
		if (_parent != value) {
			_parent = value;
			if (_parent) {
				startConsole(_parent);
			}
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function show():void {
		Cc.visible = true;
		align();
	}

	protected function fillPriorityMap():void {
		PRIORITY_MAP[LogEventLevel.INFO] = Console.INFO;
		PRIORITY_MAP[LogEventLevel.DEBUG] = Console.DEBUG;
		PRIORITY_MAP[LogEventLevel.ERROR] = Console.ERROR;
		PRIORITY_MAP[LogEventLevel.WARN] = Console.WARN;
		PRIORITY_MAP[LogEventLevel.FATAL] = Console.FATAL;
	}

	protected function startConsole(displayObject:DisplayObject):void {
		logDate = new Date();
		startTime = logDate.time;
		initialTimer = getTimer();

		//        if (displayObject as ICon§)
		Cc.config.commandLineAllowed = false;
		Cc.config.alwaysOnTop = false;
		Cc.height = 450;

		Cc.config.style.controlColor = 9109759;
		Cc.config.style.controlSize = 20;
		Cc.config.style.traceFontSize = 20;
		Cc.config.style.menuFontSize = 27;
		Cc.config.displayRollerEnabled = false;
		Cc.config.rulerToolEnabled = false;
		Cc.config.maxLines = 7000;

		Cc.startOnStage(displayObject, PASSWORD);
		Cc.visible = _visibleOnStart;
		Cc.commandLine = false;

		Cc.fpsMonitor = true;
		Cc.instance.panels.channelsPanel = true;

		var appDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
		var ns:Namespace = appDescriptor.namespace();
		var appCopyright:String = appDescriptor.ns::filename;
		var appVersion:String = appDescriptor.ns::versionNumber;
		var message:String = Capabilities.os + "\n" + Capabilities.version + "\n" + Capabilities.cpuArchitecture + "\n" + "Debugger: " + Capabilities.isDebugger + "\n" + logDate.toDateString() + "   " + logDate.toLocaleTimeString() + "\n" + "appId:" + appCopyright + "\n" + "version:" + appVersion + "\n" + all.length + "/" + Cc.config.maxLines;
		Cc.add(message);
	}

	protected function getTimeStamp(now:int):String {
		logDate.time = startTime + (now - initialTimer);
		var timestamp:String = "[" + formatTime(logDate, ":") + "] ";
		return timestamp;
	}

	protected function formatTime(date:Date, delimiter:String):String {
		date.time += 14400000; // +4 часа GMT москва
		var hours:Number = date.hoursUTC;
		var minutes:Number = date.minutesUTC;
		var seconds:Number = date.secondsUTC;
		var timestamp:String = "";
		timestamp += hours > 9 ? hours.toString() : "0" + hours;
		timestamp += delimiter;
		timestamp += minutes > 9 ? minutes.toString() : "0" + minutes;
		timestamp += delimiter;
		timestamp += seconds > 9 ? seconds.toString() : "0" + seconds;
		return timestamp;
	}

	private function align():void {
		Cc.width = 734;
		Cc.height = 350;
		Cc.x = 27;
		Cc.y = 0;

		var fpsPanel:ConsolePanel = Cc.instance.panels.getPanel(GraphingPanel.FPS);
		if (!fpsPanel) return;
		fpsPanel.height = 150;
		fpsPanel.width = 200;
		fpsPanel.x = 768 - fpsPanel.width;
		fpsPanel.y = 1004 - fpsPanel.height;

		var chPanel:ConsolePanel = Cc.instance.panels.getPanel(ChannelsPanel.NAME);
		if (!chPanel) return;
		chPanel.x = 768 - chPanel.width;
		chPanel.y = 1004 - 450;
		(chPanel as ChannelsPanel).update();
	}

	override public function logEvent(event:LogEvent):void {
		var category:String = (event.target as ILogger).category;
		for each (var name:String in excludeCategories) {
			if (category.indexOf(name) != -1) {
				return;
			}
		}
		Cc.ch(category, getTimeStamp(getTimer()) + event.message, PRIORITY_MAP[event.level]);
	}

}
}
