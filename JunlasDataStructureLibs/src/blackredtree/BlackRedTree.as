package blackredtree{
	public class BlackRedTree{
		private var root:Node;    //根节点
		private var _compareFunction:Function;//比较函数
		
		public function BlackRedTree(compareFunction:Function = null){
			if(compareFunction != null){
				_compareFunction = compareFunction;
			}else{
				_compareFunction = function (a:int,b:int):int{return a-b};
			}
		}
		
		public function insert( value:int) :void{
			if(root == null) {    //添加根节点，并将根置为黑色
				root = new Node(value);
				root.changeColor();
			} else {
				var current :Node= root;    //从根节点开始向下遍历，寻找可以插入新值的节点
				while(current.getNext(_compareFunction,value) != null) {
					fixColor(current);    //如果需要，则修正颜色
					if(!current.isCorrect()) fix(current);    //如果发生红黑冲突，则修正
					current = current.getNext(_compareFunction,value);    //继续寻找可以插入新值的下一个节点
				}
				current = current.insert(value);    //在找到的节点下插入新值
				if(!current.isCorrect()) fix(current);    //如果发生红黑冲突，则修正
			}
		}
		
		private function fixColor( node:Node):void {    //如果当前节点是红色，且两个子节点是黑色，则翻转颜色
			if(node.isBlack()
				&& node.getLeft() != null && !node.getLeft().isBlack()
				&& node.getRight() != null && !node.getRight().isBlack()) {
				if(node != root) node.changeColor();    //根始终保持黑色
				node.getLeft().changeColor();
				node.getRight().changeColor();
			}
		}
		
		private function fix( node:Node):void {    //修正红黑冲突
			var p:Node = node.getParent();    //获得父节点
			var g:Node = p.getParent();    //获得祖父节点
			if(p.isOuter(node)) {    //如果是祖父的外孙，则需要变化两次颜色，做一次旋转
				g.changeColor();
				p.changeColor();
				if(p.isLeft(node)) turnRight(g); //以祖父节点为中心做一次右旋
				else turnLeft(g);
			} else {    //如果是祖父的内孙，则需要变化两次颜色，做两次旋转
				g.changeColor();
				node.changeColor();
				if(!p.isLeft(node)) {
					turnLeft(p);    //以父节点为中心作一次左旋
					turnRight(g);    //以祖父节点为中心做一次右旋
				} else {
					turnRight(p);
					turnLeft(g);
				}
			}
		}
		
		private function turnLeft(node:Node):void {    //左旋算法
			var p:Node= node.getParent();
			var right:Node = node.getRight();   
			node.setRight(right.getLeft());
			right.setLeft(node);
			if(node == root) root = right;
			else if (p.isLeft(node)) p.setLeft(right);
			else p.setRight(right);
		}
		
		private function turnRight(node:Node):void { //右旋算法
			var p :Node= node.getParent();
			var left:Node = node.getLeft();
			node.setLeft(left.getRight());
			left.setRight(node);
			if(node == root) root = left;
			else if (p.isLeft(node)) p.setLeft(left);
			else p.setRight(left);
		}
		
		/**
		 * displayFunc的参数结构如下：
		 * @param  node:当前遍历的结点
		 * @param  level:当前结点的层深
		 */
		public function ordinal(displayFunc:Function):void {
			ordinalPrint(root,0,displayFunc);       
		}
		
		private function ordinalPrint(node:Node, level:int,displayFunc:Function):void {    //打印
			if(node ==  null) return;
			ordinalPrint(node.getLeft() , level + 1,displayFunc);
			//trace(node.value + (node.isBlack() ? " black" : " red") + " " + level);
			displayFunc(node,level);
			ordinalPrint(node.getRight() , level + 1,displayFunc);
		}
	}
}