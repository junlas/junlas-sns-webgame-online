package junlas.components.piclist{
	import junlas.utils.math.mVector;

	/**
	 *@author lvjun01
	 */
	public class JItemCompose{
		internal var itemIndex:int = 0;
		private var _itemsArr:Vector.<JListItem>;
		
		public function JItemCompose() {
			_itemsArr = new Vector.<JListItem>();
		}
		
		public function push(item:JListItem):void {
			_itemsArr.push(item);
		}
		
		public function handleItemsPos(posArr:Vector.<mVector>,pageNum:int,isTween:Boolean = true):void {
			var item:JListItem;
			for (var i:int = itemIndex; i < _itemsArr.length && i < itemIndex + pageNum; i++) {
				item = _itemsArr[i];
				item.updatePos(posArr[i - itemIndex],isTween);
			}
			
		}
		
		public function getLength():int{
			return _itemsArr.length;
		}
	}
}