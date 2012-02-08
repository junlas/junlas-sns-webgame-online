package junlas.bitmapdatas{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * 矢量动画转换位图动画<br/>
	 * 控制播放的动画的帧频从1开始
	 *@author lvjun01
	 */
	public class BmMovieClip extends Bitmap{
		public static var FrameRate:int = 24;
		private var _maxFrame:int;
		private var _currFrame:int=1;
		private var _autoPlay:Boolean;
		private var _bmArr:Array;
		private var _originalMc:MovieClip;
		
		public function BmMovieClip(originalMc:MovieClip,maxFrame:int) {
			_bmArr = [];
			_originalMc = originalMc;
			if(_originalMc && _originalMc.totalFrames < maxFrame){
				maxFrame = _originalMc.totalFrames;
			}
			_maxFrame = maxFrame;
			_originalMc && transformToArray();
		}
		
		public function run():void{
			if(!_autoPlay)return;
			++_currFrame;
			_currFrame = _currFrame>_bmArr.length?1:_currFrame;
			gotoAndStop(_currFrame);
			play();
		}
		
		/**
		 * 播放
		 */
		public function play():void{
			_autoPlay = true;
			TweenLite.delayedCall(1/FrameRate,run);
		}
		
		/**
		 * 停止
		 */
		public function stop():void{
			_autoPlay = false;
		}
		
		public function gotoAndStop(frame:int):void{
			if(frame > _maxFrame){
				if(_currFrame != _maxFrame) frame = _maxFrame;
				else return;
			}
			_autoPlay = false;
			_currFrame = frame;
			var bmdMatrix:BitmapDataMatrix = _bmArr[_currFrame-1] as BitmapDataMatrix;
			this.bitmapData = bmdMatrix.bitmapdata;
			this.transform.matrix = bmdMatrix.transformMatrix;
		}
		
		public function get currentFrame():int{
			return _currFrame;
		}
		
		public function clone():BmMovieClip{
			var bmMovieClip:BmMovieClip = new BmMovieClip(null,_maxFrame);
			bmMovieClip._currFrame = _currFrame;
			bmMovieClip._autoPlay = false;
			bmMovieClip._maxFrame = _maxFrame;
			bmMovieClip._originalMc = _originalMc;
			for (var i:int = 0; i < _bmArr.length; i++) {
				bmMovieClip._bmArr[i] = _bmArr[i].clone();
			}
			
			return bmMovieClip;
		}
		
		/**
		 * 将mc逐帧拷贝的数组_bmArr里
		 */
		private function transformToArray():void {
			for (var i:int = 0; i < _originalMc.totalFrames; i++) {
				if(i >= _maxFrame)break;
				trans2Bm(i);
			}
		}
		
		/**
		 * 将mc当前帧拷贝的数组_bmArr里
		 */
		private function trans2Bm(index:int):void {
			_originalMc.gotoAndStop(index+1);//因为MovieClip是从1开始跳帧的
			var bound:Rectangle = _originalMc.getBounds(_originalMc);
			var mtx:Matrix = new Matrix(1,0,0,1,-bound.x, -bound.y);
			var bmd:BitmapData = new BitmapData(Math.max(bound.width, 1), Math.max(bound.height, 1), true, 0x00000000);
			bmd.draw(_originalMc,mtx);
			_bmArr[index] = new BitmapDataMatrix(bmd,new Matrix(1, 0, 0, 1, bound.x, bound.y));
			//_tilesBitmap.transform.matrix = new Matrix(1, 0, 0, 1, bound.x, bound.y);
		}
		
		public function destroy():void{
			_autoPlay = false;
			_currFrame = 1;
			for(var i:int = _bmArr.length-1;i>=0;i--){
				var bmdMatrix:BitmapDataMatrix = _bmArr[i];
				bmdMatrix.destroy();
			}
			_bmArr = null;
		}
		
	}
}

