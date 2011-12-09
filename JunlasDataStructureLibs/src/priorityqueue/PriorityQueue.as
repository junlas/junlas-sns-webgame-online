package priorityqueue{
	public class PriorityQueue{
		private var _heap:Heap;
		private var _compareFunction:Function;
		
		public function PriorityQueue(compareFunc:Function = null)
		{
			if(compareFunc != null){
				_compareFunction = compareFunc;
			}else{
				_compareFunction = function(a:int,b:int):int{return a-b}
			}
			_heap = new Heap(_compareFunction);
		}
		
		public function put(value:Object):void{
			_heap.enqueue(value);
		}
		
		public function out():Object{
			return _heap.dequeue();
		}
		
		public function getLength():int{
			return _heap.length;
		}
		
		public function getData():Array{
			return _heap.heap;
		}
		
		public function destroy():void{
			_heap.destroy();
		}
	}
}