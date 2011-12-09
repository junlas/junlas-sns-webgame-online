package searchtree{
	public class Node{
		private var _value:Object;
		private var _left:Node;
		private var _right:Node;
		
		public function Node( value:Object) {
			this._value = value;
		}
		
		public function getValue():Object {
			return _value;
		}
		
		public function setLeft( left:Node):void{
			this._left = left;
		}
		
		public function setRight( right:Node):void {
			this._right = right;
		}
		
		public function getLeft():Node {
			return _left;
		}
		
		public function getRight():Node {
			return _right;
		}
	}
}