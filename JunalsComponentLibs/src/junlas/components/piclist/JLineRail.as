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
		private var _separatePoints:Vector.<mVector>;
		
		public function JLineRail(start:mVector,end:mVector) {
			_start = start;
			_end = end;
			_separatePoints = new Vector.<mVector>();
		}
		
		/**
		 * 创建分割点
		 */
		public function createSeparate(pageNum:int,itemRadius:Number):void {
			var isHorizontal:Boolean;
			if(_start.y == _end.y){//横向的list
				isHorizontal = true;
				_start.x -= itemRadius;
				_end.x += itemRadius;
			} else if(_start.x == _end.x){//竖向的list
				isHorizontal = false;
				_start.y -= itemRadius;
				_end.y += itemRadius;
			}
			var unitDis:Number = _end.distance(_start) / (pageNum + 1);
			for(var i:int = 0;i <= (pageNum+1);i++){
				if(isHorizontal){
					_separatePoints[i] = _start.plus(new mVector(i*unitDis));
				}else{
					_separatePoints[i] = _start.plus(new mVector(0,i*unitDis));
				}
			}
			drawSeparate();
		}
		
		public function drawLine(content:Sprite):void {
			if(JPiclist.__debug__){
				removeDebugRelation();
				_debugLineContent = new Shape();
				_debugLineContent.graphics.lineStyle(3,0x00aacc);
				_debugLineContent.graphics.moveTo(_start.x,_start.y);
				_debugLineContent.graphics.lineTo(_end.x,_end.y);
				_debugLineContent.graphics.endFill();
				content.addChild(_debugLineContent);
			}
		}
		
		private function drawSeparate():void{
			if(JPiclist.__debug__){
				//线条重新绘制
				_debugLineContent.graphics.clear();
				_debugLineContent.graphics.lineStyle(3,0x00aacc);
				_debugLineContent.graphics.moveTo(_start.x,_start.y);
				_debugLineContent.graphics.lineTo(_end.x,_end.y);
				_debugLineContent.graphics.endFill();
				//绘制分割点
				for each (var p:mVector in _separatePoints) {
					_debugLineContent.graphics.beginFill(0xaabbcc);
					_debugLineContent.graphics.drawCircle(p.x,p.y,5);
					_debugLineContent.graphics.endFill();
				}
			}
		}
		
		public function getPosPoints():Vector.<mVector>{
			return _separatePoints;
		}
		
		public function removeDebugRelation():void{
			if(_debugLineContent){
				_debugLineContent.graphics.clear();
				if(_debugLineContent.parent){
					_debugLineContent.parent.removeChild(_debugLineContent);
				}
			}
			_debugLineContent = null;
		}
		
		public function destroy():void {
			removeDebugRelation();
			
		}
	}
}