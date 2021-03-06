package dittner.testmyself.core.command {
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.core.service.NoteService;

public class GetNoteExamplesCmd implements ISFCommand {

	[Inject]
	public var service:NoteService;

	public function execute(msg:IRequestMessage):void {
		service.loadExamples(msg);
	}
}
}