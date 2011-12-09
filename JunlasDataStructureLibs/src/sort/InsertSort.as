package sort {
	/**
	 * 插入排序
	 *@author lvjun01
	 */
	public class InsertSort{
		internal var _dataArr :Vector.<Object>;
		private var _compare:Function;
		
		public function InsertSort(compare:Function = null) {
			_dataArr = new Vector.<Object>(); 
			if(compare==null)
				_compare =  function (a:int,b:int):int{return a-b};
			else
				_compare = compare;
		}
		/** 默认是不排序的 **/
		public function push(data:*):void{
			if(data is Array || data is Vector.<Object>){
				for each (var item:Object in data) {
					insert(item);
				}
				return;
			}
			_dataArr.push(data);
		}
		/** 默认是不排序的 **/
		public function pushAt(data:Object,index:int):void{
			_dataArr.splice(index,0,1);
		}
		/** 默认是排序的 **/
		public function insert(data:*):void {
			if(data is Array || data is Vector.<Object>){
				for each (var item:Object in data) {
					insert(item);
				}
				return;
			}
			_dataArr.push(data);
			sort();
		}
		/**插入排序算法**/
		public function sort():void{
			var temp:Object;
			for(var i:int = 1;i<_dataArr.length;i++){
				var pos:int = i;
				temp = _dataArr[i];
				while(pos > 0 && _compare(_dataArr[pos -1],temp) > 0){
					_dataArr[pos] = _dataArr[pos - 1];
					--pos;
				}
				_dataArr[pos] = temp;
			}
		}
		/**原生排序算法**/
		public function sortByOriginal():void{
			_dataArr.sort(_compare);
		}
		
		public function getSortIndex(item:Object):int{
			return _dataArr.indexOf(item);
		}
		
		public function deleteItem(item:Object):void{
			var index:int =  _dataArr.indexOf(item);
			if(index != -1){
				_dataArr.splice(index,1);
			}
		}
		
		public function contains(item:Object):Boolean{
			return _dataArr.indexOf(item) != -1;
		}
		
		public function get dataArr():Vector.<Object>{
			return _dataArr;
		}
		
		public function print():void{
			for each (var data:Object in _dataArr) {
				trace("data:",data);
			}
			
		}
		
		public function destroy():void{
			_dataArr = null;
			_compare = null;
		}
	}
}
