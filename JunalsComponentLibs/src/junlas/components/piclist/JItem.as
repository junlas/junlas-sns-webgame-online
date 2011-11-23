package junlas.components.piclist{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import junlas.utils.math.mVector;

	/**
	 *@author lvjun01
	 */
	public class JItem{
		////在debug模式下,debug父容器////
		private var _debugPmc:Sprite;
		private var _debugChild:Sprite;
		
		private var _pmc:Sprite;
		private var _car:JCar;
		private var _child:DisplayObject;
		
		public function JItem(pmc:Sprite,child:DisplayObject) {
			_pmc = pmc;
			_child = child;
			_car = new JCar();
		}
		
		public function initDebugPmc(debugPmc:Sprite):void {
			_debugPmc = debugPmc;
			_debugChild = new Sprite();
			_debugChild.graphics.beginFill(0xcc0033,.3);
			_debugChild.graphics.drawCircle(0,0,15);
			_debugChild.graphics.endFill();
			var tf:TextField = new TextField();
			tf.text = "" + _car.myIndex;
			tf.selectable = false;
			tf.width = tf.height = 20;
			tf.x = -5; 
			tf.y = -8;
			_debugChild.addChild(tf);
			_debugChild.mouseChildren = _debugChild.mouseEnabled = false;
		}
		
		public function setItsIndex(index:int):void {
			_car.myIndex = index;
		}
		
		public function getItsIndex():int{
			return _car.myIndex;
		}
		
		public function getPos():mVector {
			return _car.pos;
		}
		
		public function go(speed:mVector):void{
			updatePos(_car.pos.plusEquals(speed));
		}
		
		public function updatePos(pos:mVector):void{
			_car.pos = pos;
			if(JPiclist.__debug__){
				_debugPmc.addChild(_debugChild);
				_debugChild.x = _car.pos.x;
				_debugChild.y = _car.pos.y;
			}
		}
		
		public function stopUpdatePos():void {
			if(JPiclist.__debug__){
				_debugPmc.removeChild(_debugChild);
			}
		}
		
	}
}