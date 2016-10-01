package de.dittner.testmyself.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.ui.common.page.INotePage;

import mx.collections.ArrayCollection;

public class SelectExamplesByPageOperation extends StorageOperation implements IAsyncCommand {

	public function SelectExamplesByPageOperation(storage:Storage, page:INotePage) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:INotePage;

	public function execute():void {
		if (page.noteColl.length > 0) {
			for each(var note:Note in page.noteColl) {
				if (storage.exampleHash[note.id]) {
					var examples:Array = [];
					var example:Note;
					for each(var exampleData:Object in storage.exampleHash[note.id]) {
						example = note.createExample();
						example.deserialize(exampleData);
						examples.push(example);
					}
					note.exampleColl = new ArrayCollection(examples);
				}
			}
		}
		dispatchSuccess();
	}

}
}