package sort{
	import flash.errors.IllegalOperationError;

	/**
	 * 支持插入排序和二分排序2中方式
	 *@author lvjun01
	 */
	public class InsertBinarySort{
		private var _insertSort:InsertSort;
		private var _binarySort:BinarySort;
		private var _hasOK:Boolean = true;
		/**数据,由我来保管，你懂的**/
		private var _dataArr:Vector.<Object>;
		private var _compareFunc:Function;
		
		public function InsertBinarySort(compare:Function = null) {
			_dataArr = new Vector.<Object>();
			if(compare==null)
				_compareFunc =  function (a:int,b:int):int{return a-b};
			else
				_compareFunc = compare;
			_insertSort = new InsertSort(_compareFunc);
			_insertSort._dataArr = _dataArr;
			_binarySort = new BinarySort(_compareFunc);
			_binarySort._dataArr = _dataArr;
		}
		
		/**
		 * 插入数据无排序:普通插入
		 */
		public function insertDataNotSort(data:Object):void{
			_insertSort.push(data);
			_hasOK = false;
		}
		
		/**
		 * 插入数据即排序
		 */
		public function insertDataGoOnSort(data:Object):void{
			if(!_hasOK)throw new IllegalOperationError("请检测,数据数组不是有序,不能调用'插入数据即排序'函数");
			_binarySort.insert(data);
		}
		
		/**排序数据，基于插入排序算法**/
		public function sortDataOnInsertMethod():void{
			_insertSort.sort();
			_hasOK = true;
		}
		
		/**排序数据，基于原生排序算法**/
		public function sortDataOnOriginalMethod():void{
			_insertSort.sortByOriginal();
			_hasOK = true;
		}
		
		/** 打印 **/
		public function print():void{
			for each (var data:Object in _dataArr) {
				trace("data:",data);
			}
		}
		
		/** 销毁 **/		
		public function destroy():void {
			_insertSort.destroy();
			_binarySort.destroy();
			_dataArr = null;
			_compareFunc = null;
		}

		/**排序完成与否的一个状态标识**/
		public function get hasOK():Boolean {
			return _hasOK;
		}

	}
}