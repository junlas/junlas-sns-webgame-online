package searchtree{
	/**
	 * @author lvjun
	 * 1.无论是二叉搜索树还是 红黑树，如果有保存有相同数据，那么查找所有相同的数据，是一个很负责的过程.<br>
	 * 2.二叉搜索树和红黑树在插入和删除操作，时间复杂度在O(n)和O(logn)之间，至少红黑树要比二叉搜索树要负责一点.<br>
	 * 3.二叉搜索树和红黑树在查找上的效率几乎完全一样.<br>
	 * 4.红黑树的优势在于:对于有序数据的遍历相关操作是绝对优势.<br>
	 */
	public class SearchTree{
		private var root:Node;
		private var _compareFunction:Function;
		private var _orderIndex:int;
		public var dataArr:Vector.<Object>;
		
		public function SearchTree(compareFunction:Function = null){
			if(compareFunction != null){
				_compareFunction = compareFunction;
			}else{
				_compareFunction = function (a:int,b:int):int{return a-b};
			}
			dataArr = new Vector.<Object>();
		}
		
		public function addValue(value:Object):void {
			 
			dataArr.push(value);
			var node:Node = new Node(value);   
			if(root == null) root = node;
			else addNode(root,node);
		}
		
		private function addNode( current:Node,  node:Node):void {
			
			if(_compareFunction(node.getValue(),current.getValue()) < 0) {
				if(current.getLeft() == null) current.setLeft(node);
				else addNode(current.getLeft(), node);
			} else{// if(_compareFunction(node.getValue(),current.getValue()) > 0) {
				if(current.getRight() == null) current.setRight(node);
				else addNode(current.getRight(), node);
			}
		}
		
		public function containsValue( value:Object):Boolean {
			if(root == null) return false;
			else return containsNode(root,value);
		}
		
		private function containsNode( current:Node,  value:Object):Boolean {
			if(current == null) return false;
			if(current.getValue() == value) return true;//current.getValue() == value
			if(_compareFunction(value,current.getValue()) < 0) return containsNode(current.getLeft(),value);//value < current.getValue()
			else return containsNode(current.getRight(),value);
		}
		
		public function removeValue(value:Object):void {
			var index:int = dataArr.indexOf(value);
			if(index != -1){
				dataArr.splice(index,1);
			}
			removeNode(null,root,value);
		}
		
		private function removeNode( parent:Node,  current:Node,  value:Object):void {
			if(current == null) return;
			if(current.getValue() == value) {
				var node:Node;
				if(current.getLeft() == null && current.getRight() ==  null) node = null;
				else if (current.getLeft() != null && current.getRight() == null) node = current.getLeft();
				else if (current.getRight() != null && current.getLeft() == null) node = current.getRight();
				else {
					node = removeMin(current,current.getRight());
					node.setLeft(current.getLeft());
					node.setRight(current.getRight());
				}
				if(parent == null) root = node;
				else if(parent.getLeft() == current) parent.setLeft(node);
				else parent.setRight(node);
			} else if(_compareFunction(value,current.getValue()) < 0) removeNode(current,current.getLeft(),value);//value < current.getValue()
			else removeNode(current,current.getRight(),value);
		}
		
		private function removeMin( parent:Node,  current:Node):Node {
			if(current.getLeft() != null) return removeMin(current,current.getLeft());
			else {
				if(parent.getLeft() == current) parent.setLeft(current.getRight());//parent.getLeft() == current
				else parent.setRight(current.getRight());
				return current;
			}
		}
		
		public function max():Object {
			if(root == null) return -1;
			else return maxNode(root);
		}

		private function maxNode( current:Node):Object {
			if(current.getRight() == null) return current.getValue();
			else return maxNode(current.getRight());
		}
		
		public function min():Object {
			if(root == null) return -1;
			else return minNode(root);
		}
		
		private function minNode( current:Node):Object {
			if(current.getLeft() == null) return current.getValue();
			else return minNode(current.getLeft());
		}
		
		
		/**
		 * displayFunc的结构如下:
		 * @param node：当前结点
		 * @param order:当前结点的序列索引
		 */
		public function ordinal(displayFunc:Function):void {
			if (root == null) return;
			else {
				_orderIndex = 0;
				ordinalPrint(root,displayFunc);
			}
		}
		
		private function ordinalPrint( current:Node,displayFunc:Function):void {
			if(current.getLeft() != null) ordinalPrint(current.getLeft(),displayFunc);
			displayFunc(current,_orderIndex++);
			//trace(current.getValue() + " ");
			if(current.getRight() != null) ordinalPrint(current.getRight(),displayFunc);
			
		}
		
		public function destroy():void{
			root = null;
			_compareFunction = null;
			_orderIndex = 0;
			dataArr = null;
		}
	}
}