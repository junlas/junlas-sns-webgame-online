package junlas.components.piclist{
	import junlas.utils.math.mVector;

	/**
	 *@author lvjun01
	 */
	public class JDataInfo{
		internal var _contentArr:Vector.<JItem>;
		internal var _firstShowIndex:int;
		internal var _pageNum:int;
		internal var _itemRadius:Number;
		internal var _speed:Number;
		internal var _betweenSidesDist:Number;
		internal var _isCircle:Boolean;
		//一次缓动设置移动的数目//
		internal var _tweenItemNumAtOnce:int = 1;
		///速度向量与其反向量 ///
		private var _speedVector:mVector;
		private var _speedNegateVector:mVector;
		
		public function calculateSpeedVect(betweenPointsVector:mVector):void{
			_speedVector = betweenPointsVector.clone();
			_speedVector.length = _speed;
			_speedNegateVector = _speedVector.negate();
		}
		
		///速度向量///
		public function get speedVector():mVector {
			return _speedVector;
		}
		
		///速度反向量///
		public function get speedNegateVector():mVector {
			return _speedNegateVector;
		}

		public function destroy():void {
			for each (var item:JItem in _contentArr) {
				item.destroy();
			}
			_contentArr = null;
		}
	}
}