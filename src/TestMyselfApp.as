package {
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;

import flash.events.UncaughtErrorEvent;

import spark.components.Application;

public class TestMyselfApp extends Application {
	public function TestMyselfApp() {
		super();
		addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
	}

	private function uncaughtErrorHandler(event:UncaughtErrorEvent):void {
		var error:* = event.error;
		if (error is Error) {
			CLog.err(LogCategory.UNCHAUGHT, (error as Error).getStackTrace().toString());
		}
		else {
			CLog.err(LogCategory.UNCHAUGHT, error ? error.toString() : "unknown error");
		}
	}
}
}
