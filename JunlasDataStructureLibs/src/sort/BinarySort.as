package sort{
	/**
	 * 二分法排序
	 *@author lvjun01
	 */
	public class BinarySort{
		internal var _dataArr :Vector.<Object>;
		private var _compare:Function;
		
		public function BinarySort(compare:Function = null) {
			_dataArr = new Vector.<Object>(); 
			if(compare==null)
				_compare =  function (a:int,b:int):int{return a-b};
			else
				_compare = compare;
		}
		
		/** 插入数据的同时,排序 **/
		public function insert(data:*):void {
			if(data is Array || data is Vector.<Object>){
				for each (var item:Object in data) {
					insert(item);
				}
				return;
			}
			sort(data);
		}
		
		/** 排序算法 **/
		private function sort(data:Object):void {
			var start:int = 1;
			var end:int = _dataArr.length;
			var m:int = (start + end)>>1;
			while(start<=end){
				if(_compare(data,_dataArr[m-1]) > 0){
					start = m + 1;
				}
				if(_compare(data,_dataArr[m-1]) < 0){
					end = m - 1;
				}
				if(_compare(data,_dataArr[m-1]) == 0) break;
				m = (start + end)/2;
			}
			_dataArr.splice(m,0,data);
		}
		
		/** 获取排序后的索引值 **/
		public function getSortIndex(item:Object):int{
			return _dataArr.indexOf(item);
		}
		
		/** 删除一个item **/
		public function deleteItem(item:Object):void{
			var index:int =  _dataArr.indexOf(item);
			if(index != -1){
				_dataArr.splice(index,1);
			}
		}
		
		/** 包含 **/
		public function contains(item:Object):Boolean{
			return _dataArr.indexOf(item) != -1;
		}
		
		/** 原生数据数组 **/
		public function get dataArr():Vector.<Object>{
			return _dataArr;
		}
		
		/** 打印 **/
		public function print():void{
			for each (var data:Object in _dataArr) {
				trace("data:",data);
			}
			
		}
		
		/** 销毁  **/
		public function destroy():void{
			_dataArr = null;
			_compare = null;
		}
	}
}