package de.dittner.testmyself.backend.command {
import de.dittner.testmyself.backend.SQLStorage;

public class GetNoteCmd implements ISFCommand {

	[Inject]
	public var service:SQLStorage;

	public function execute(msg:IRequestMessage):void {
		service.loadNote(msg);
	}

}
}