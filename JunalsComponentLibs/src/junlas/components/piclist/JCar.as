package junlas.components.piclist{
	
	/**
	 * 最终的显示效果，是来自于这个car的坐标和速度决定显示对象的定位
	 *@author lvjun01
	 */
	public class JCar{
		private var _xpos:Number;
		private var _ypos:Number;
		private var _radius:Number;
		
		public function JCar(xpos:Number = 0,ypos:Number = 0,radius:Number = 0) {
			_xpos = xpos;
			_ypos = ypos;
			_radius = radius;
		}
	}
}