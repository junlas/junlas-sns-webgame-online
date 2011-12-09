package heaptree{
	public class HeapTree{
		private var array:Vector.<Node>;	//序排序的数组
		private var pos:int;	//当前有效数据的个数
		private var _compareFunction:Function;
		
		public function HeapTree(compareFunc:Function = null) {
			array = new Vector.<Node>();
			if(compareFunc != null){
				_compareFunction = compareFunc;
			}else{
				_compareFunction = function(a:int,b:int):int{return a-b;}
			}
		}
		
		public function add( node:Node):void  {	//将新数据插入数组
			array[pos] = node;	//将新数据插入数组的最后（堆的最后一个元素之后）
			trickleUp(pos++);	//将数据提升致恰当的位置
		}
		
		public function remove():Node {	//删除堆的顶
			var result:Node = array[0];	//将最后一个元素提至堆定
			array[0] = array[--pos];	//将堆顶下降为恰当位置
			trickleDown(0);
			return result;
		}
		
		public function isEmpty():Boolean {
			return pos == 0;
		}
		/**
		 * 将指定位置的节点，按照堆的约定规则向上调整到合适的位置
		 */
		private function trickleUp( index:int):void {
			var bottom:Node = array[index];		//暂存要提升的数据
			var parent:int = getParent(index);	//得到父节点的位置
			//如果节点存在，且父节点的关键字的值小于要提升数据的关键字
			while (index > 0 && _compareFunction(array[parent].value,bottom.value) < 0) {//array[parent].key() < bottom.key()
				array[index] = array[parent];	//将父节点下降，留出空位
				index = parent;	//重复以上过程
				parent = getParent(index);
			}
			array[index] = bottom;	//将暂存的数据放入恰当的位置
		}
		
		/**
		 * 将指定位置的节点，按照堆的约定规则向下调整到合适的位置
		 */
		private function trickleDown( index:int):void {
			var top:Node = array[index];	//存放要下降的数据
			var left:int = getLeft(index);	//得到左子的位置
			var right:int = getRight(index);	//得到右子的位置
			var current:int;	//当前可能要下降的位置
			
			if(left < pos && right < pos)	//左右子节点有效，当前的位置设置为左右子节点中小的那个
				current = _compareFunction(array[left].value,array[right].value) > 0 ? left : right;	//array[left].key() > array[right].key()
			else if (left < pos) current = left;	//如果左子节点有效，则当前位置设置为左子节点
			else current = -1;	//没有可以下降的位置
			while(current != -1 && _compareFunction(array[current].value,top.value) > 0) {	//当前节点有效且大于要下降的数据//array[current].key() > top.key()
				array[index] = array[current];	//将当前节点向上提升，留出空位
				index = current;	//重复以上过程
				left = getLeft(index);
				right = getRight(index);
				if(left < pos && right < pos)
					current = _compareFunction(array[left].value,array[right].value) > 0 ? left : right;//array[left].key() > array[right].key()
				else if (left < pos) current = left;
				else current = -1;
			}
			array[index] = top;	//将暂存的数据放入恰当的位置
		}
		
		private function getParent( index:int):int {
			return (index-1)/2;
		}
		
		private function getLeft( index:int):int {
			return 2 * index + 1;
		}
		
		private function getRight( index:int):int {
			return 2 * index + 2;
		}
		
		/**
		 * 预留方法:堆排序(不足够的灵活,仍有优化的空间)<br>
		 * 注意:该方法，一旦调用过以后，此堆就为空了，因为不是正确的堆；<br>
		 */
		public function sort():void {
			var i:int;
			/*for(var i:int=array.length/2 -1; i>=0; i--) {  
				trickleDown(i);  
			}*/
			for(i=array.length-1; i>=0;i--) array[i] = remove();
		}
		
		public function destroy():void
		{
			array = null;
			pos = 0;
			_compareFunction = null;
		}
		
		/**
		 * 测试用例
		 */
		public function print():void {
			for(var i:int=0; i<pos; i++) {
				trace(array[i].value.num + ","+array[i].value.name);
			}
		}
		
		/**
		 * 测试用例
		 */
		public function print2():void {
			for each(var node:Node in array)
				trace(node.value.num + ","+node.value.name);
		}
		
		/**
		 * 测试用例
		 */
		public function print3():void
		{
			while(!isEmpty()) {
				var node:Node = remove();
				trace(node.value.num + " = " + node.value.name);
			}
		}
	}
}