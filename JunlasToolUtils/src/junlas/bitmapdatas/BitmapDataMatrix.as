package junlas.bitmapdatas{
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	/**
	 *@author lvjun01
	 */
	public class BitmapDataMatrix{
		public function BitmapDataMatrix(bitmapdata:BitmapData,transformMatrix:Matrix)
		{
			_bitmapdata = bitmapdata;
			_transformMatrix = transformMatrix;
		}
		
		private var _bitmapdata:BitmapData;
		private var _transformMatrix:Matrix;

		public function get bitmapdata():BitmapData {
			return _bitmapdata;
		}

		public function get transformMatrix():Matrix {
			return _transformMatrix;
		}
		
		public function clone():BitmapDataMatrix{//.clone()//.clone()
			var bmdMatrix:BitmapDataMatrix = new BitmapDataMatrix(_bitmapdata,_transformMatrix.clone());
			return bmdMatrix;
		}

		/**
		 * 销毁操作
		 */
		public function destroy():void {
			_bitmapdata.dispose();
			_bitmapdata = null;
			_transformMatrix = null;
		}
	}
}