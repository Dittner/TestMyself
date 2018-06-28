package de.dittner.testmyself.utils {
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getTimer;

public class ActualDate {
	public function ActualDate() {}

	private static var curDate:Date;
	private static var timer:Timer;
	private static var startTime:Number;

	private static function createDate():void {
		curDate = new Date();
		startTime = curDate.time - getTimer();

		timer = new Timer(10 * 60 * 1000);
		timer.addEventListener(TimerEvent.TIMER, timerHandler);
		timer.start();
	}

	private static function timerHandler(e:TimerEvent):void {
		curDate.time = startTime + getTimer();
	}

	public static function get time():Number {
		if(!curDate) createDate();
		return curDate.time;
	}

	public static function get fullYear():Number {
		if(!curDate) createDate();
		return curDate.fullYear;
	}

	public static function get month():Number {
		if(!curDate) createDate();
		return curDate.month;
	}

	public static function get date():Number {
		if(!curDate) createDate();
		return curDate.date;
	}

	public static function get hours():Number {
		if(!curDate) createDate();
		return curDate.hours;
	}

	public static function get minutes():Number {
		if(!curDate) createDate();
		return curDate.minutes;
	}

	public static function get seconds():Number {
		if(!curDate) createDate();
		return curDate.seconds;
	}
}
}
