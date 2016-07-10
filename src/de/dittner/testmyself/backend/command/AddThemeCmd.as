package de.dittner.testmyself.backend.command {
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.message.IRequestMessage;
import de.dittner.testmyself.backend.NoteService;

public class AddThemeCmd implements ISFCommand {

	[Inject]
	public var service:NoteService;

	public function execute(msg:IRequestMessage):void {
		service.addTheme(msg);
	}
}
}
