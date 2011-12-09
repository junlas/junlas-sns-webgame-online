package blackredtree{
	public class Node{
		private var _value:Object;    //数值
		private var _parent:Node;
		private var _left:Node;
		private var _right:Node;
		private var _isBlack:Boolean;
		
		public function Node(value:int) {
			this._value = value; 
		}
		
		public function  insert( value:int):Node {
			var node:Node = new Node(value);
			if(value < this._value) setLeft(node);
			else setRight(node);
			return node;
		}
		
		public function  isCorrect():Boolean {    //返回当前节点是否与父节点都是红色，如果是，则返回fasle
			return !(_parent != null && !_parent._isBlack && !_isBlack);
		}
		
		public function getNext(compareFunc:Function, value:int):Node {    //根据给定的值返回下一个可以插入数据的节点
			if(compareFunc(value, this._value) < 0) return _left;
			else return _right;
		}
		
		public function setLeft( node:Node) :void{
			_left = node;
			if(node != null) node._parent = this;
		}
		
		public function  getLeft():Node {
			return _left; 
		}
		
		public function setRight( node:Node):void {
			_right = node;
			if(node != null) node._parent = this;
		}
		
		public function getRight():Node {
			return _right; 
		}
		
		public function get value():Object {
			return _value; 
		}
		
		public function  getParent():Node {
			return _parent; 
		}
		
		public function isOuter( node:Node):Boolean {    //判断父节点与当前节点，当前节点与给定子节点是否在同一方向
			return _parent.isLeft(this) && this.isLeft(node) ||
				!_parent.isLeft(this) && !this.isLeft(node);
		}
		
		public function isLeft( node:Node):Boolean {
			return node == _left; 
		}
		
		public function  changeColor():void {
			_isBlack = !_isBlack; 
		}
		
		public function isBlack():Boolean {
			return _isBlack; 
		}
	}
}