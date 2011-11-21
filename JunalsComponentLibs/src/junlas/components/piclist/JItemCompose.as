package junlas.components.piclist{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import junlas.utils.math.MathTool;
	import junlas.utils.math.mVector;

	/**
	 *@author lvjun01
	 */
	public class JItemCompose{
		private var _goItemsNum:int = 0;
		private var _currIndex:int;
		private var _minPosIndex:int;
		private var _maxPosIndex:int;
		
		private var _pageNum:int;
		private var _moveGroup:JMoveGroup;
		
		private var _itemsArr:Vector.<JListItem>;
		
		public function JItemCompose() {
			_itemsArr = new Vector.<JListItem>();
			_minPosIndex = _maxPosIndex = 0;
			_moveGroup = new JMoveGroup();
		}
		
		public function push(item:JListItem):void {
			_itemsArr.push(item);
		}
		
		public function setMaxItemIndex(pageNum:int):void {
			_pageNum = pageNum;
			_maxPosIndex = pageNum + 1;
		}
		
		public function run():void {
			
		}
		
		public function go(runSpeed:mVector):void {
			var item:JListItem;
			/*if(_goItemsNum > 0){
				for (var i:int = 0; i < _moveGroup._itemArr.length; i++) {
					item = _moveGroup._itemArr[i];
					TweenLite.to(item,2,{x:_moveGroup._posArr[item.PosIndex].x,y:_moveGroup._posArr[item.PosIndex].y,ease:Back.easeOut});
				}
				
			}else{
			
			}*/
		}
		
		public function updateNextItemIndex(itemsNum:int,isCircle:Boolean):void {
			_goItemsNum = itemsNum;
		}
		
		/**
		 * 缓动效果
		 */
		public function handleMoveItemsPos(posArr:Vector.<mVector>,itemRadius:Number):void {
			if(posArr.length <= 0)return;
			_moveGroup.reset();
			_moveGroup.updatePosArr(posArr);
			var absVal:int = MathTool.abs(_goItemsNum);
			var normalVal:int = MathTool.normal(_goItemsNum);
			var item:JListItem;
			var itemPosIndex:int;
			if(normalVal > 0){
				var maxIndex:int = _currIndex + _pageNum + absVal-1 <= (getLength()-1)?_currIndex + _pageNum + absVal-1:(getLength()-1);
				for(var i:int = _currIndex;i<maxIndex;i++){
					item = _itemsArr[i];
					item.updateCarRadius(itemRadius);
					itemPosIndex = i-_currIndex + 1>_maxPosIndex?_maxPosIndex:i-_currIndex + 1;
					item.updatePos(posArr[itemPosIndex]);
					itemPosIndex = itemPosIndex + _goItemsNum > _maxPosIndex ? _maxPosIndex:itemPosIndex + _goItemsNum;
					item.PosIndex = itemPosIndex;
					trace(item.PosIndex);
					_moveGroup.push(item);
				}
			}else{
				var minIndex:int = _currIndex-absVal+1>=0?_currIndex-absVal+1:0;
				for(i = minIndex;i<_currIndex+_pageNum;i++){
					item = _itemsArr[i];
					item.updateCarRadius(itemRadius);
					itemPosIndex = i-minIndex+1<_minPosIndex?_minPosIndex:i-minIndex+1;
					item.updatePos(posArr[itemPosIndex]);
					itemPosIndex = itemPosIndex + _goItemsNum < _minPosIndex ? _minPosIndex : itemPosIndex + _goItemsNum;
					item.PosIndex = itemPosIndex;
					_moveGroup.push(item);
				}
			}
		}
		/**
		 * 不做缓动效果，直接以
		 * @param beginIndex
		 * 这个作为起始点立即显示列表
		 */
		public function handleSolidItemsPos(beginIndex:int,posArr:Vector.<mVector>,itemRadius:Number):void{
			_goItemsNum = 0;
			//直接显示Item在对应的坐标下
			var item:JListItem;
			for (var i:int = beginIndex;i < beginIndex + _pageNum; i++) {
				item = _itemsArr[i];
				item.updateCarRadius(itemRadius);
				item.PosIndex = i-beginIndex+1;
				item.updatePos(posArr[item.PosIndex]);
			}
			_currIndex = beginIndex;
		}
		
		public function getLength():int{
			return _itemsArr.length;
		}
	}
}

import junlas.components.piclist.JListItem;
import junlas.utils.math.mVector;

class JMoveGroup{
	public var _posArr:Vector.<mVector>;
	public var _itemArr:Vector.<JListItem>;
	
	public function JMoveGroup(){
		_itemArr = new Vector.<JListItem>();
	}
	
	public function updatePosArr(posArr:Vector.<mVector>):void {
		_posArr = posArr;
	}
	
	public function push(item:JListItem):void{
		_itemArr.push(item);
	}

	public function reset():void {
		while(_itemArr.length)_itemArr.pop();
	}
};