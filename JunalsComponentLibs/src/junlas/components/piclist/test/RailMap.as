package junlas.components.piclist.test {
	import flash.display.*;
	import junlas.utils.math.*;
	
	public class RailMap {
		public static var __debug__:Boolean = false;
		
		private var _railArr:Array;
		private var _isCircular:Boolean;
		private var _totalDistance:Number;
		private var _debugMc:Sprite;
		
		public function RailMap(_arg1:Sprite=null){
			if (__debug__){
				this._debugMc = new Sprite();
				_arg1.addChild(this._debugMc);
			};
			this._isCircular = false;
			this._railArr = new Array();
		}
		public function del():void{
			var _local1:int;
			while (_local1 < this._railArr.length) {
				(this._railArr[_local1] as AbstractRail).del();
				_local1++;
			};
			this._railArr = null;
			if (this._debugMc){
				this._debugMc.parent.removeChild(this._debugMc);
				this._debugMc = null;
			};
		}
		public function addCar(_arg1:Car):void{
			_arg1.railMap = this;
			if (((__debug__) && (this._debugMc))){
				_arg1.debugMc = this._debugMc;
			};
		}
		public function set rails(_arg1:Array):void{
			var _local3:AbstractRail;
			this._totalDistance = 0;
			this._railArr = new Array();
			var _local2:int;
			while (_local2 < _arg1.length) {
				_local3 = (_arg1[_local2] as AbstractRail);
				if (_local3){
					this._railArr.push(_local3);
					if (((__debug__) && (this._debugMc))){
						_local3.debugMc = this._debugMc;
					};
					this._totalDistance = (this._totalDistance + _local3.distance);
				};
				_local2++;
			};
		}
		public function get rails():Array{
			return (this._railArr);
		}
		public function set isCircular(_arg1:Boolean):void{
			this._isCircular = _arg1;
		}
		public function get isCircular():Boolean{
			return (this._isCircular);
		}
		public function get totalDistance():Number{
			return (this._totalDistance);
		}
		function getPoint(_arg1:Car):mVector{
			var _local5:AbstractRail;
			if (((!(this._railArr)) || ((this._railArr.length == 0)))){
				return (new mVector());
			};
			if (_arg1.isDerailed() < 0){
				return ((this._railArr[0] as AbstractRail).getPointByDistance(0));
			};
			if (_arg1.isDerailed() > 0){
				return ((this._railArr[(this._railArr.length - 1)] as AbstractRail).getPointByDistance((this._railArr[(this._railArr.length - 1)] as AbstractRail).distance));
			};
			var _local2:Number = (_arg1.distance % this.totalDistance);
			_local2 = ((_local2 >= 0)) ? _local2 : (this.totalDistance + _local2);
			var _local3:Number = 0;
			var _local4:int;
			while (_local4 < this._railArr.length) {
				_local5 = this._railArr[_local4];
				_local3 = (_local3 + _local5.distance);
				if (_local3 > _local2){
					return (_local5.getPointByDistance((_local2 - (_local3 - _local5.distance))));
				};
				_local4++;
			};
			return (new mVector());
		}
		function getRotation(_arg1:Car):Number{
			var _local5:AbstractRail;
			if (((!(this._railArr)) || ((this._railArr.length == 0)))){
				return (0);
			};
			if (_arg1.isDerailed() < 0){
				return ((this._railArr[0] as AbstractRail).getRotationByDistance(0));
			};
			if (_arg1.isDerailed() > 0){
				return ((this._railArr[(this._railArr.length - 1)] as AbstractRail).getRotationByDistance((this._railArr[(this._railArr.length - 1)] as AbstractRail).distance));
			};
			var _local2:Number = (_arg1.distance % this.totalDistance);
			_local2 = ((_local2 >= 0)) ? _local2 : (this.totalDistance + _local2);
			var _local3:Number = 0;
			var _local4:int;
			while (_local4 < this._railArr.length) {
				_local5 = this._railArr[_local4];
				_local3 = (_local3 + _local5.distance);
				if (_local3 > _local2){
					return (_local5.getRotationByDistance((_local2 - (_local3 - _local5.distance))));
				};
				_local4++;
			};
			return (0);
		}
		
	}
}//package zlong.breathxue.utils.RailMap 