package junlas.components.piclist{
	import junlas.utils.math.mVector;

	/**
	 *@author lvjun01
	 */
	public class JItemCompose{
		internal var currItemIndex:int = 0;
		internal var nextItemIndex:int = 0;
		private var _minIndex:int;
		private var _maxIndex:int;
		
		private var _posArr:Vector.<mVector>;
		private var _pageNum:int;
		//////
		private var _runSpeed:mVector;
		private var _haveShowArr:Vector.<JListItem>;
		private var _willShowArr:Vector.<JListItem>;
		
		private var _itemsArr:Vector.<JListItem>;
		
		public function JItemCompose() {
			_itemsArr = new Vector.<JListItem>();
			_minIndex = _maxIndex = 0;
			_haveShowArr = new Vector.<JListItem>();
			_willShowArr = new Vector.<JListItem>();
		}
		
		public function push(item:JListItem):void {
			_itemsArr.push(item);
		}
		
		public function updateNextItemIndex(itemsNum:int,isCircle:Boolean):void {
			nextItemIndex += itemsNum;
			if(!isCircle){
				nextItemIndex = (nextItemIndex > (_maxIndex-_pageNum) ? (_maxIndex-_pageNum):nextItemIndex);
			}
			nextItemIndex = nextItemIndex < _minIndex ? _minIndex:nextItemIndex;
			nextItemIndex = nextItemIndex > _maxIndex ? _maxIndex:nextItemIndex;
		}
		
		public function setMaxItemIndex(pageNum:int):void {
			_pageNum = pageNum;
			_maxIndex = pageNum + 1;
		}
		
		public function run():void {
			if(currItemIndex == nextItemIndex)return;
			for (var i:int = 0; i < _willShowArr.length; i++) {
				var item:JListItem = _willShowArr[i];
				if(item.pos().distance(_willShowArr[_minIndex].pos()) < _runSpeed.length || item.pos().distance(_willShowArr[_minIndex].pos()) > _runSpeed.length){
					currItemIndex += (nextItemIndex-currItemIndex)/Math.abs(nextItemIndex-currItemIndex);
					continue;
				}
				item.updatePos(item.pos().plusEquals(_runSpeed));
			}
			
		}
		
		public function go(runSpeed:Number):void {
			_runSpeed = _posArr[_maxIndex].minus(_posArr[_minIndex]);
			_runSpeed.length = runSpeed;
		}
		
		public function handleItemsPos(posArr:Vector.<mVector>,itemRadius:Number):void {
			if(posArr.length <= 0)return;
			while(_willShowArr.length)_willShowArr.pop();
			_posArr = posArr;
			var item:JListItem;
			for (var i:int = nextItemIndex;i < nextItemIndex + _pageNum; i++) {
				item = _itemsArr[i];
				item.updateCar(itemRadius);
				if(i>=currItemIndex+_pageNum){
					item.updatePos(posArr[_maxIndex]);
				}else if(i<currItemIndex){
					item.updatePos(posArr[_minIndex]);
				}else{
					item.updatePos(posArr[i-nextItemIndex+1]);
				}
				_willShowArr.push(item);
			}
		}
		
		public function getLength():int{
			return _itemsArr.length;
		}
	}
}