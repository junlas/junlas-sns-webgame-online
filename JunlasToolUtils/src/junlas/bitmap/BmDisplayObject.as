package junlas.bitmap{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 *@author lvjun01
	 */
	public class BmDisplayObject extends Bitmap{
		private var _originalMc:DisplayObject;
		private var _bmd:BitmapData;
		private var _mat:Matrix;
		
		public function BmDisplayObject(mc:DisplayObject) {
			_originalMc = mc;
			_originalMc && trans2Bm();
		}
		
		/**
		 * 将mc转换成bitmapdata
		 */
		private function trans2Bm():void {
			var bound:Rectangle = _originalMc.getBounds(_originalMc);
			var mtx:Matrix = new Matrix(1,0,0,1,-bound.x, -bound.y);
			_bmd = new BitmapData(Math.max(bound.width, 1), Math.max(bound.height, 1), true, 0x00000000);
			_bmd.draw(_originalMc,mtx);
			this.bitmapData = _bmd;
			_mat = new Matrix(1, 0, 0, 1, bound.x, bound.y);
			this.transform.matrix = _mat;
		}
		
		public function clone():BmDisplayObject{
			var bmDisplayObject:BmDisplayObject = new BmDisplayObject(null);
			bmDisplayObject._originalMc = _originalMc;
			bmDisplayObject.bitmapData = _bmd;
			bmDisplayObject.transform.matrix = _mat.clone();
			return bmDisplayObject;
		}
		
		public function destroy():void{
			_originalMc = null;
			_bmd.dispose();
			_mat = null;
			_bmd = null;
		}
		
	}
}