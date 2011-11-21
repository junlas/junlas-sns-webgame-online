package junlas.components.piclist{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import junlas.utils.math.mVector;

	/**
	 *@author lvjun01
	 */
	public class JListItem{
		private var _debugItemContent:Sprite; 
		/////
		private var _pmc:Sprite;
		internal var PosIndex:int;
		internal var GoStep:int;
		private var _car:JCar;
		private var _content:DisplayObject;
		
		public function JListItem(pmc:Sprite,content:DisplayObject) {
			_pmc = pmc;
			_content = content;
			_car = new JCar(0,0);
		}
		
		public function updateCarRadius(itemRadius:Number):void {
			_car.radius = itemRadius;
		}
		
		public function updatePos(pos:mVector):void {
			var debugMC:Sprite;
			_car.postion = pos;
			_content.x = _car.postion.x;
			_content.y = _car.postion.y;
			_pmc.addChild(_content);
			if(JPiclist.__debug__){
				debugMC = _car.getDebugMc();
				_debugItemContent.addChild(debugMC);
			}
		}
		
		public function get x():Number{
			return _car.postion.x;
		}
		
		public function set x(val:Number):void{
			updatePos(new mVector(val,_car.postion.y));
		}
		
		public function get y():Number{
			return _car.postion.y;
		}
		
		public function set y(val:Number):void{
			updatePos(new mVector(_car.postion.x,val));
		}
		
		public function pos():mVector{
			return _car.postion;
		}
		
		public function initDebugPmc(debugPmc:Sprite):void{
			_debugItemContent = new Sprite();
			debugPmc.addChild(_debugItemContent);
		}
	}
}