package de.dittner.testmyself.backend.command {
import de.dittner.testmyself.backend.SQLStorage;

public class AddThemeCmd implements ISFCommand {

	[Inject]
	public var service:SQLStorage;

	public function execute(msg:IRequestMessage):void {
		service.storeTheme(msg);
	}
}
}
