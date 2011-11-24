package junlas.components.piclist{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import junlas.utils.math.mVector;

	/**
	 *@author lvjun01
	 */
	public class JLineRail{
		private var _debugLineContent:Shape;
		//////////////////
		private var _start:mVector;
		private var _end:mVector;
		private var _dataInfo:JDataInfo;
		
		private var _posLeftPoint:mVector;
		private var _posRightPoint:mVector;
		private var _startPosInFactPoint:mVector;
		private var _endPosInFactPoint:mVector;
		///连续的两个点间向量与其反向量////
		private var _distanceInFact:mVector;
		private var _distanceNegateInFact:mVector;
		
		private var _radiusVector:mVector;
		///起点与终点间向量///
		private var _betweenPointsVector:mVector;
		
		public function JLineRail(start:mVector,end:mVector,dataInfo:JDataInfo) {
			_start = start;
			_end = end;
			_dataInfo = dataInfo;
			_betweenPointsVector = _end.minus(_start);
			init();
		}
		
		public function init():void{
			_radiusVector = _betweenPointsVector.clone();
			_radiusVector.length = _dataInfo._itemRadius;
			_posLeftPoint = _start.plus(_radiusVector.negate());
			_posRightPoint = _end.plus(_radiusVector);
			createSeparate();
		}
		
		/**
		 * 创建分割点
		 */
		public function createSeparate():void {
			//要预防当_dataInfo._pageNum <= 1的这种情况，一直要做好判断
			var directionVect:mVector = _end.minus(_start);
			_startPosInFactPoint = directionVect.clone();
			_startPosInFactPoint.length = _dataInfo._betweenSidesDist;
			_startPosInFactPoint.plusEquals(_radiusVector);
			_endPosInFactPoint = _startPosInFactPoint.mult(-1);
			_startPosInFactPoint.plusEquals(_start);
			_endPosInFactPoint.plusEquals(_end);
			
			if(_dataInfo._pageNum > 1){
				_distanceInFact = _endPosInFactPoint.minus(_startPosInFactPoint);
				(_distanceInFact.length = _distanceInFact.length / (_dataInfo._pageNum-1));
			}else{
				_distanceInFact = directionVect.clone();
				_distanceInFact.length = _dataInfo._itemRadius*2;
			}
			_distanceNegateInFact = _distanceInFact.negate();
			if(_dataInfo._pageNum <= 1){
				_endPosInFactPoint = _startPosInFactPoint;
			}
		}
		
		public function drawDebug(content:Sprite):void {
			if(JPiclist.__debug__){
				_debugLineContent = new Shape();
				_debugLineContent.graphics.lineStyle(3,0x00aacc);
				_debugLineContent.graphics.moveTo(_posLeftPoint.x,_posLeftPoint.y);
				_debugLineContent.graphics.lineTo(_posRightPoint.x,_posRightPoint.y);
				_debugLineContent.graphics.endFill();
				content.addChild(_debugLineContent);
			}
			drawSeparate();
		}
		
		private function drawSeparate():void{
			if(JPiclist.__debug__){
				//绘制分割点
				for(var i:int = 0;i<_dataInfo._pageNum;i++){
					var distance:mVector = _distanceInFact.clone();
					distance.length = _distanceInFact.length * i;
					var nextPoint:mVector = _startPosInFactPoint.plus(distance);
					_debugLineContent.graphics.lineStyle(1,0xaabbcc);
					_debugLineContent.graphics.beginFill(0xaabbcc);
					_debugLineContent.graphics.drawCircle(nextPoint.x,nextPoint.y,20);
					_debugLineContent.graphics.endFill();
				}
				_debugLineContent.graphics.beginFill(0xffcc00);
				_debugLineContent.graphics.drawCircle(_startPosInFactPoint.x,_startPosInFactPoint.y,5);
				_debugLineContent.graphics.endFill();
				_debugLineContent.graphics.beginFill(0xffcc00);
				_debugLineContent.graphics.drawCircle(_endPosInFactPoint.x,_endPosInFactPoint.y,5);
				_debugLineContent.graphics.endFill();
			}
		}
		
		private function removeDebugRelation():void{
			if(_debugLineContent){
				_debugLineContent.graphics.clear();
				if(_debugLineContent.parent){
					_debugLineContent.parent.removeChild(_debugLineContent);
				}
			}
			_debugLineContent = null;
		}
		
		/**
		 * 销毁操作
		 */
		public function destroy():void {
			removeDebugRelation();
			_dataInfo = null;
		}

		/**
		 * 起点坐标
		 */
		public function get startPosInFactPoint():mVector {
			return _startPosInFactPoint;
		}
		
		/**
		 * 终点坐标
		 */
		public function get endPosInFactPoint():mVector {
			return _endPosInFactPoint;
		}
		
		/**
		 * 距离向量
		 */
		public function get distanceInFact():mVector {
			return _distanceInFact;
		}
		
		/**
		* 距离反向量
		*/
		public function get distanceNegateInFact():mVector {
			return _distanceNegateInFact;
		}

		/**
		 * 左边点向量
		 */
		public function get posLeftPoint():mVector {
			return _posLeftPoint;
		}

		/**
		 * 右边点向量
		 */
		public function get posRightPoint():mVector {
			return _posRightPoint;
		}
		
		/**
		 * 起点->终点2点之间的向量
		 */
		public function get betweenPointsVector():mVector {
			return _betweenPointsVector;
		}


	}
}