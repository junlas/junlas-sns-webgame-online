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
		private var _debugMC:Sprite;
		/////
		private var _postion:mVector;
		private var _radius:Number;
		
		public function JCar(xpos:Number = 0,ypos:Number = 0,radius:Number = 0) {
			_postion = new mVector(xpos,ypos);
			_radius = radius;
			if(JPiclist.__debug__){
				_debugMC = new Sprite();
				var tf:TextField = new TextField();
				tf.text = "radius"+_radius;
				tf.x = -tf.textWidth>>1;
				tf.selectable = false;
				_debugMC.addChild(tf);
			}
		}
		
		public function get postion():mVector{
			return _postion;
		}
		
		public function set postion(pos:mVector):void{
			_postion = pos;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(value:Number):void {
			_radius = value;
		}
		
		public function getDebugMc():Sprite {
			_debugMC.graphics.clear();
			_debugMC.graphics.beginFill(0x66ff00,.3);
			_debugMC.graphics.drawCircle(0,0,_radius);
			_debugMC.graphics.endFill();
			_debugMC.x = _postion.x;
			_debugMC.y = _postion.y;
			return _debugMC;
		}

	}
}