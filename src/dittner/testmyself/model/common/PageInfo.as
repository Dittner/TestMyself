package dittner.testmyself.model.common {
public class PageInfo implements IPageInfo {

	//--------------------------------------
	//  pageNum
	//--------------------------------------
	private var _pageNum:uint = 0;
	public function get pageNum():uint {return _pageNum;}
	public function set pageNum(value:uint):void {
		_pageNum = value;
	}

	//--------------------------------------
	//  pageSize
	//--------------------------------------
	private var _pageSize:uint = 10;
	public function get pageSize():uint {return _pageSize;}
	public function set pageSize(value:uint):void {
		_pageSize = value;
	}

	//--------------------------------------
	//  selectedTransUnit
	//--------------------------------------
	private var _selectedTransUnit:ITransUnit;
	public function get selectedTransUnit():ITransUnit {return _selectedTransUnit;}
	public function set selectedTransUnit(value:ITransUnit):void {
		_selectedTransUnit = value;
	}

	//--------------------------------------
	//  transUnits
	//--------------------------------------
	private var _transUnits:Array = [];
	public function get transUnits():Array {return _transUnits;}
	public function set transUnits(value:Array):void {
		_transUnits = value;
	}

	//--------------------------------------
	//  filter
	//--------------------------------------
	private var _filter:Array = [];
	public function get filter():Array {return _filter;}
	public function set filter(value:Array):void {
		_filter = value;
	}

}
}
