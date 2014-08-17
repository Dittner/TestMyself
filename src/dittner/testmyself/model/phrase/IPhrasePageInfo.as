package dittner.testmyself.model.phrase {
public interface IPhrasePageInfo {

	function get pageNum():uint;
	function get pageSize():uint;
	function get selectedPhrase():IPhrase;
	function get phrases():Array;
	function get filter():Array;
}
}
