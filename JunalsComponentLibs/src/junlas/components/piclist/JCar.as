package junlas.components.piclist{
	import junlas.utils.math.mVector;
	
	/**
	 * 最终的显示效果，是来自于这个car的坐标和速度决定显示对象的定位
	 *@author lvjun01
	 */
	public class JCar{
		private var _postion:mVector;
		
		public function JCar(xpos:Number = 0,ypos:Number = 0) {
			_postion = new mVector(xpos,ypos);
		}
		
		public function get postion():mVector{
			return _postion;
		}
		
		public function set postion(pos:mVector):void{
			_postion = pos;
		}
	}
}