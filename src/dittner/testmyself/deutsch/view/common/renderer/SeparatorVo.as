package dittner.testmyself.deutsch.view.common.renderer {
public class SeparatorVo {
	public function SeparatorVo(gap:Number = 5, thickness:Number = 1, color:uint = 0xffFFff, alpha:Number = 1) {
		_gap = gap;
		_thickness = thickness;
		_color = color;
		_alpha = alpha;
	}

	//--------------------------------------
	//  gap
	//--------------------------------------
	private var _gap:Number;
	public function get gap():Number {return _gap;}

	//--------------------------------------
	//  thickness
	//--------------------------------------
	private var _thickness:Number;
	public function get thickness():Number {return _thickness;}

	//--------------------------------------
	//  color
	//--------------------------------------
	private var _color:uint;
	public function get color():uint {return _color;}

	//--------------------------------------
	//  alpha
	//--------------------------------------
	private var _alpha:Number;
	public function get alpha():Number {return _alpha;}

}
}
