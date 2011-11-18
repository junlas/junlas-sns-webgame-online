package  junlas.components.piclist.test {
	import flash.display.*;
	import junlas.utils.math.*;
	
	public class CurveRail extends AbstractRail {
		public static var MINI_BLOCK:Number = 1;
		
		private var _p0:mVector;
		private var _p1:mVector;
		private var _p2:mVector;
		private var _partT:Number;
		private var blockLengthArr:Array;
		private var _distance:Number;
		private var _tdebugMc:Shape;
		
		public function CurveRail(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:Number){
			this._p0 = new mVector(_arg1, _arg2);
			this._p1 = new mVector(_arg3, _arg4);
			this._p2 = new mVector(_arg5, _arg6);
			this.block();
		}
		private function block():void{
			this.blockLengthArr = new Array();
			this._partT = (1 / ((this._p1.minus(this._p0).length + this._p2.minus(this._p1).length) / MINI_BLOCK));
			this._distance = 0;
			var _local1:mVector = new mVector(this._p0.x, this._p0.y);
			var _local2:mVector = new mVector(0, 0);
			var _local3:Number = this._partT;
			while (_local3 < 1) {
				_local2.x = (((this._p0.x * Math.pow((1 - _local3), 2)) + (((this._p1.x * 2) * _local3) * (1 - _local3))) + ((this._p2.x * _local3) * _local3));
				_local2.y = (((this._p0.y * Math.pow((1 - _local3), 2)) + (((this._p1.y * 2) * _local3) * (1 - _local3))) + ((this._p2.y * _local3) * _local3));
				this.blockLengthArr.push(_local2.minus(_local1).length);
				this._distance = (this._distance + _local2.minus(_local1).length);
				_local1 = _local2.clone();
				_local3 = (_local3 + this._partT);
			};
		}
		override public function del():void{
			if (this._tdebugMc){
				this._tdebugMc.parent.removeChild(this._tdebugMc);
				this._tdebugMc = null;
			};
			this._p0 = null;
			this._p1 = null;
			this._p2 = null;
			this.blockLengthArr = null;
		}
		override public function get distance():Number{
			return (this._distance);
		}
		override public function getPointByDistance(_arg1:Number):mVector{
			var _local4:Number;
			var _local5:mVector;
			if (_arg1 >= this.distance){
				return (this._p2);
			};
			if (_arg1 <= 0){
				return (this._p0);
			};
			var _local2:Number = 0;
			var _local3:int;
			while (_local3 < this.blockLengthArr.length) {
				_local2 = (_local2 + this.blockLengthArr[_local3]);
				if (_local2 >= _arg1){
					_local4 = (_local3 * this._partT);
					_local5 = new mVector(0, 0);
					_local5.x = (((this._p0.x * Math.pow((1 - _local4), 2)) + (((this._p1.x * 2) * _local4) * (1 - _local4))) + ((this._p2.x * _local4) * _local4));
					_local5.y = (((this._p0.y * Math.pow((1 - _local4), 2)) + (((this._p1.y * 2) * _local4) * (1 - _local4))) + ((this._p2.y * _local4) * _local4));
					return (_local5);
				};
				_local3++;
			};
			return (this._p2);
		}
		override public function getRotationByDistance(_arg1:Number):Number{
			var _local4:Number;
			var _local5:mVector;
			var _local6:mVector;
			if (_arg1 >= this.distance){
				return (this._p2.minus(this._p1).angle);
			};
			if (_arg1 <= 0){
				return (this._p1.minus(this._p0).angle);
			};
			var _local2:Number = 0;
			var _local3:int;
			while (_local3 < this.blockLengthArr.length) {
				_local2 = (_local2 + this.blockLengthArr[_local3]);
				if (_local2 >= _arg1){
					_local4 = (_local3 * this._partT);
					_local5 = new mVector(0, 0);
					_local6 = new mVector(0, 0);
					_local5.x = (this._p0.x + ((this._p1.x - this._p0.x) * _local4));
					_local5.y = (this._p0.y + ((this._p1.y - this._p0.y) * _local4));
					_local6.x = (this._p1.x + ((this._p2.x - this._p1.x) * _local4));
					_local6.y = (this._p1.y + ((this._p2.y - this._p1.y) * _local4));
					return (_local6.minus(_local5).angle);
				};
				_local3++;
			};
			return (this._p2.minus(this._p1).angle);
		}
		override public function get startPoint():mVector{
			return (this._p0);
		}
		override public function get endPoint():mVector{
			return (this._p2);
		}
		override function set debugMc(_arg1:Sprite):void{
			this._tdebugMc = new Shape();
			_arg1.addChild(this._tdebugMc);
			this._tdebugMc.graphics.lineStyle(1, 153);
			this._tdebugMc.graphics.moveTo(this._p0.x, this._p0.y);
			this._tdebugMc.graphics.curveTo(this._p1.x, this._p1.y, this._p2.x, this._p2.y);
		}
		public function get p0():mVector{
			return (this._p0);
		}
		public function get p1():mVector{
			return (this._p1);
		}
		public function get p2():mVector{
			return (this._p2);
		}
		
	}
}//package zlong.breathxue.utils.RailMap 