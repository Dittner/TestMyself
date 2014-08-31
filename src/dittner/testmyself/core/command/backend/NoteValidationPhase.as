package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.note.Note;

public class NoteValidationPhase extends PhaseOperation {
	public function NoteValidationPhase(note:Note) {
		this.note = note;
	}

	private var note:Note;

	override public function execute():void {
		if (!note)
			throw new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует единица перевода");
		else if (note.title && note.description)
			dispatchComplete();
		else
			throw new CommandException(ErrorCode.FORM_NOT_FILLED, "Форма не заполнена: заголовок и описание не должны быть пустыми");
	}

	override public function destroy():void {
		super.destroy();
		note = null;
	}
}
}
