package junlas.components.piclist{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import junlas.utils.math.mVector;
	
	/**
	 * 最终的显示效果，是来自于这个car的坐标和速度决定显示对象的定位
	 *@author lvjun01
	 */
	public class JCar{
		private var _myIndex:int;
		private var _pos:mVector;
		
		public function JCar(xpos:Number = 0,ypos:Number = 0,radius:Number = 0) {
		}
		
		public function get myIndex():int{
			return _myIndex;
		}
		
		public function set myIndex(index:int):void{
			_myIndex = index;
		}
		
		public function get pos():mVector{
			return _pos;
		}
		
		public function set pos(pos:mVector):void{
			_pos = pos;
		}

	}
}