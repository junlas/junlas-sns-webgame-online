package  junlas.components.piclist.test {
	import flash.display.*;
	
	public class Car {
		private var _distance:Number;
		private var _railMap:RailMap;
		private var _tdebugMc:Shape;
		
		public function Car(_arg1:Number=0){
			this._distance = _arg1;
		}
		public function del():void{
			if (this._tdebugMc){
				this._tdebugMc.parent.removeChild(this._tdebugMc);
				this._tdebugMc = null;
			};
			this._railMap = null;
		}
		public function forward(_arg1:Number):void{
			if (!this._railMap){
				return;
			};
			this._distance = (this._distance + _arg1);
		}
		public function back(_arg1:Number):void{
			if (!this._railMap){
				return;
			};
			this._distance = (this._distance - _arg1);
		}
		public function isDerailed():int{
			if (!this._railMap){
				return (1);
			};
			if (!this._railMap.isCircular){
				if (this._distance > this._railMap.totalDistance){
					return (1);
				};
				if (this._distance < 0){
					return (-1);
				};
			};
			return (0);
		}
		public function print():void{
			if (this._tdebugMc){
				this._tdebugMc.x = this.x;
				this._tdebugMc.y = this.y;
				this._tdebugMc.rotation = this.rotation;
			};
		}
		public function get x():Number{
			if (this._railMap == null){
				return (0);
			};
			return (this._railMap.getPoint(this).x);
		}
		public function get y():Number{
			if (this._railMap == null){
				return (0);
			};
			return (this._railMap.getPoint(this).y);
		}
		public function get rotation():Number{
			if (this._railMap == null){
				return (0);
			};
			return (this._railMap.getRotation(this));
		}
		function set debugMc(_arg1:Sprite):void{
			this._tdebugMc = new Shape();
			_arg1.addChild(this._tdebugMc);
			this._tdebugMc.graphics.beginFill(0x990000);
			this._tdebugMc.graphics.drawRect(-3, -2, 6, 4);
			this._tdebugMc.graphics.endFill();
			this.print();
		}
		function set railMap(_arg1:RailMap):void{
			this._railMap = _arg1;
		}
		function get railMap():RailMap{
			return (this._railMap);
		}
		public function set distance(_arg1:Number):void{
			this._distance = _arg1;
		}
		public function get distance():Number{
			return (this._distance);
		}
		
	}
}//package zlong.breathxue.utils.RailMap 