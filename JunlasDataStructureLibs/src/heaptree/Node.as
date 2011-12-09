package heaptree{
	public class Node{
		private var _value:Object;	//数据
		
		public function Node(value:Object) {
			this._value = value;
		}
		
		public function get value():Object { return _value; }
	}
}