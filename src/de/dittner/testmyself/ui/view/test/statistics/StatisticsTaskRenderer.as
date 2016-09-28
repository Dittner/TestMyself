package de.dittner.testmyself.ui.view.test.statistics {
import de.dittner.testmyself.model.domain.test.TestID;
import de.dittner.testmyself.ui.view.noteList.components.renderer.NoteRenderer;

public class StatisticsTaskRenderer extends NoteRenderer {
	public function StatisticsTaskRenderer() {
		super();
	}

	override protected function updateData():void {
		showWordArticle = testTask && word && word.article && (selected || testTask.test.id != TestID.SELECT_ARTICLE);
		super.updateData();
	}

}
}
