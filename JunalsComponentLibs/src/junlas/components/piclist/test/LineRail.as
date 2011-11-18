package junlas.components.piclist.test {
	import flash.display.*;
	import junlas.utils.math.*;
	
	public class LineRail extends AbstractRail {
		private var _sp:mVector;
		private var _ep:mVector;
		private var _tdebugMc:Shape;
		
		public function LineRail(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number){
			this._sp = new mVector(_arg1, _arg2);
			this._ep = new mVector(_arg3, _arg4);
		}
		override public function del():void{
			if (this._tdebugMc){
				this._tdebugMc.parent.removeChild(this._tdebugMc);
				this._tdebugMc = null;
			};
			this._sp = null;
			this._ep = null;
		}
		override public function get distance():Number{
			return (this._ep.minus(this._sp).length);
		}
		override public function getPointByDistance(_arg1:Number):mVector{
			if (_arg1 >= this.distance){
				return (this._ep);
			};
			if (_arg1 <= 0){
				return (this._sp);
			};
			var _local2:mVector = this._ep.minus(this._sp);
			_local2.length = _arg1;
			return (_local2.plusEquals(this._sp));
		}
		override public function getRotationByDistance(_arg1:Number):Number{
			return (this._ep.minus(this._sp).angle);
		}
		override public function get startPoint():mVector{
			return (this._sp);
		}
		override public function get endPoint():mVector{
			return (this._ep);
		}
		override function set debugMc(_arg1:Sprite):void{
			this._tdebugMc = new Shape();
			_arg1.addChild(this._tdebugMc);
			this._tdebugMc.graphics.lineStyle(1, 153);
			this._tdebugMc.graphics.moveTo(this._sp.x, this._sp.y);
			this._tdebugMc.graphics.lineTo(this._ep.x, this._ep.y);
		}
		public function get sp():mVector{
			return (this._sp);
		}
		public function get ep():mVector{
			return (this._ep);
		}
		
	}
}//package zlong.breathxue.utils.RailMap 