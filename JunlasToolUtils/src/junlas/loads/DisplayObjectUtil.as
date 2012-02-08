package junlas.loads
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;

	/**
	 *显示对象相关工具包 
	 * @author senkay
	 * 
	 */
	public class DisplayObjectUtil
	{

 		/**
		 * 让mc以及所有mc内部的mc都停止播放
		 */
/* 		public static function stopAllMCs(mc:MovieClip):void
		{
			mc.stop();
			for(var i:int=mc.numChildren - 1; i >= 0; i--)
			{
				var o:MovieClip=mc.getChildAt(i)as MovieClip;
				if (o != null)
				{
					o.stop();
				}
			}
		} */
		
		/**
		 *清空容器 
		 * @param container
		 * 
		 */		
		public static function clearContainer(container:DisplayObjectContainer):void{
			while (container.numChildren>0) container.removeChildAt(0);
		}
		
		public static function stopAllMovie(mc:MovieClip):void
		{
			if (mc is MovieClip)
			{
				mc.gotoAndStop(1);
			}
			if (mc is DisplayObjectContainer)
			{
				var n:int=DisplayObjectContainer(mc).numChildren;
				for(var i:int=0; i < n; i++)
				{
					var dis:MovieClip=DisplayObjectContainer(mc).getChildAt(i)as MovieClip;
					stopAllMovie(dis);
				}
			}
		}

		/**
		 * Create a sprite at specified parent with specified name.
		 * The created sprite default property is mouseEnabled=false.
		 * @return the sprite
		 */
		public static function createSprite(parent:DisplayObjectContainer=null, name:String=null):Sprite
		{
			var sp:Sprite=new Sprite();
			sp.focusRect=false;
			if (name != null)
			{
				sp.name=name;
			}
			sp.mouseEnabled=false;
			if (parent != null)
			{
				parent.addChild(sp);
			}
			return sp;
		}

		public static function removeDisplayObject(dis:DisplayObject):void
		{
			if (dis != null && dis.parent != null/* && dis.parent.contains(dis)*/)
			{
				dis.parent.removeChild(dis);
			}
		}
		
		/*public static function removeMovieClip(dis:MovieClip):void
		{
			if (dis != null && dis.parent != null && dis.parent.contains(dis))
			{
				stopAllMovie(dis as MovieClip);
				dis.parent.removeChild(dis);
			}
		}*/

		/**
		 * 得到显示对象的层数
		 * @parm dis 显示对象
		 * @return int 层数
		 */
		public static function getLayerIndexOfDisplayObject(dis:DisplayObject):int
		{
			var parent:DisplayObjectContainer=dis.parent;
			if (parent)
			{
				return parent.getChildIndex(dis);
			}
			else
			{
				return 0;
			}
		}

		public static function getMouseListenerDisplayList(mc:DisplayObject):void
		{
			if (mc is InteractiveObject)
			{
				if (!(mc is TextField) && InteractiveObject(mc).mouseEnabled == true)
				{
					if (havaAllMouseListener(InteractiveObject(mc)) == false)
					{
						InteractiveObject(mc).mouseEnabled=false;
						trace("NAME=" + mc.name + " String=" + mc.toString());
					}
				}
			}
			if (mc is DisplayObjectContainer)
			{
				var n:int=DisplayObjectContainer(mc).numChildren;
				for(var i:int=0; i < n; i++)
				{
					var dis:DisplayObject=DisplayObjectContainer(mc).getChildAt(i);
					getMouseListenerDisplayList(dis);
				}
			}
		}

		private static function havaAllMouseListener(obj:InteractiveObject):Boolean
		{
			var hasListener:Boolean=false;
			if (obj.hasEventListener(MouseEvent.CLICK) || obj.hasEventListener(MouseEvent.MOUSE_DOWN) || obj.hasEventListener(MouseEvent.MOUSE_MOVE) || obj.hasEventListener(MouseEvent.MOUSE_OUT) || obj.hasEventListener(MouseEvent.MOUSE_OVER) || obj.hasEventListener(MouseEvent.MOUSE_UP))
			{
				hasListener=true;
			}
			return hasListener;
		}
		
		/**
		 *复制displayObject 
		 * @param target
		 * @param autoAdd
		 * @return 
		 * 
		 */		
		public static function dupDisObj(target:DisplayObject, autoAdd:Boolean = false):DisplayObject{
			if (target is Bitmap){
				target = new Bitmap((Bitmap(target).bitmapData));
				return target;			
			}
			// create dup
			var targ:Class = Object(target).constructor;//=target["constructor"]
			var dup:DisplayObject = new targ();
			// dup properties
			dup.transform = target.transform;
			dup.filters = target.filters;
			dup.cacheAsBitmap = target.cacheAsBitmap;
			dup.opaqueBackground = target.opaqueBackground;
			if(target.scale9Grid){
			 	 var rect:Rectangle = target.scale9Grid;
			 	 // Flash 9 bug where returned scale9Grid is 20x larger than assigned
				  //
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20
				dup.scale9Grid = rect
			}
			if (dup is MovieClip){
				stopAllMovie(MovieClip(dup));
			}
			if(autoAdd && target.parent){
			  target.parent.addChild(dup);
			  dup.x = target.x;
			  dup.y = target.y;
			}
			return dup;
		}

		public static function getMovieClip(name:String):MovieClip 
		{
			var mc:MovieClip = null;
			if ( ApplicationDomain.currentDomain.hasDefinition(name) ) {
				var cls:Class = getDefinitionByName(name) as Class;
				mc = new cls() as MovieClip;
			}
			return mc;
		}
		
		public static function getSprite(name:String):Sprite 
		{
			var mc:Sprite = null;
			if ( ApplicationDomain.currentDomain.hasDefinition(name) ) {
				var cls:Class = getDefinitionByName(name) as Class;
				mc = new cls() as Sprite;
			}
			return mc;
		}
		
		public static function getTextField(name:String):TextField 
		{
			var mc:TextField = null;
			if ( ApplicationDomain.currentDomain.hasDefinition(name) ) {
				var cls:Class = getDefinitionByName(name) as Class;
				mc = new cls() as TextField;
			}
			return mc;
		}
		
		public static function getDisplayObjectContainer(name:String):DisplayObjectContainer 
		{
			var mc:DisplayObjectContainer = null;
			if ( ApplicationDomain.currentDomain.hasDefinition(name) ) {
				var cls:Class = getDefinitionByName(name) as Class;
				mc = new cls() as DisplayObjectContainer;
			}
			return mc;
		}
		
		public static function getDisplayObject(name:String):DisplayObject
		{
			var mc:DisplayObject = null;
			if ( ApplicationDomain.currentDomain.hasDefinition(name) ) {
				var cls:Class = getDefinitionByName(name) as Class;
				mc = new cls() as DisplayObject;
			}
			return mc;
		}
		
		public static function getBitmapData(name:String):BitmapData
		{
			var mc:BitmapData = null;
			if ( ApplicationDomain.currentDomain.hasDefinition(name) ) {
				var cls:Class = getDefinitionByName(name) as Class;
				mc = new cls() as BitmapData;
			}
			return mc;
		}
		
		
		public static function drawRectangleBorder(gp:Graphics, w:Number, h:Number, thickness:Number, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void {
			gp.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
			gp.moveTo(0, 0);
			gp.lineTo(w, 0);
			gp.moveTo(w, 0);
			gp.lineTo(w, h);
			gp.moveTo(w, h);
			gp.lineTo(0, h);
			gp.moveTo(0, h);
			gp.lineTo(0, 0);
		}
		
		/**
		 * 根据disItem.parent容器的所有子显示对象的Y值排列层深
		 * @param disItem
		 * disItem.parent != null
		 * 二分查找
		 */		
		public static function updateItemDepthByY(disItem:DisplayObject):void {
			var container:DisplayObjectContainer = disItem.parent;
			var chn:int = container.numChildren;
			if (chn == 1) {
				
			}
			else
			if (chn == 2) {
				var ch1:DisplayObject = container.getChildAt(0);
				var ch2:DisplayObject = container.getChildAt(1);
				if (ch1.y > ch2.y) {
					container.swapChildrenAt(0, 1);
				}
			}
			else {
				container.removeChild(disItem);
				--chn;
				var i:int = 0;
				var j:int = chn - 1;
				while (true) {
					var mid:int = (i + j) / 2;
					var tch:DisplayObject = container.getChildAt(mid);
					if (tch.y < disItem.y) {
						i = mid + 1;
					}
					else
					if (tch.y > disItem.y) {
						j = mid - 1;
					}
					else {
						container.addChildAt(disItem, mid);
						break;
					}
					
					if (i == j) {
						tch = container.getChildAt(i);
						if (tch.y < disItem.y) {
							container.addChildAt(disItem, i + 1);
						}
						else {
							container.addChildAt(disItem, i);
						}
						break;
					}
					else
					if (i > j) {
						container.addChildAt(disItem, i);
						break;
					}
				}
			}
		}
		
		/**
		 * 根据disItem.parent容器的所有子显示对象的Y值排列层深
		 * @param disItem
		 * disItem.parent != null
		 * 二分查找
		 */		
		public static function binaryUpdateItemDepthByY(disItem:DisplayObject):void {
			var container:DisplayObjectContainer = disItem.parent;
			var chn:int = container.numChildren;
			if (chn == 1) {
				
			}
			else
			if (chn == 2) {
				var ch1:DisplayObject = container.getChildAt(0);
				var ch2:DisplayObject = container.getChildAt(1);
				if (ch1.y > ch2.y) {
					container.swapChildrenAt(0, 1);
				}
			}
			else {
				container.removeChild(disItem);
				var bottom:int = 0;
				var top:int = chn - 2;
				while (top > bottom) {
					var mid:int = (top + bottom) / 2;
					var ch:DisplayObject = container.getChildAt(mid);
					if (ch.y == disItem.y) {
						container.addChildAt(disItem, mid);
						break;
					}
					else
					if (ch.y > disItem.y) {
						top = mid - 1;
						
						if (top < bottom) {
							container.addChildAt(disItem, mid);
							break;
						}
						else
						if (top == bottom) {
							ch = container.getChildAt(bottom);
							if (ch.y > disItem.y) {
								container.addChildAt(disItem, bottom);
							}
							else {
								container.addChildAt(disItem, mid);
							}
							break;
						}
					}
					else {
						bottom = mid + 1;
						
						if (top <= bottom) {
							ch = container.getChildAt(top);
							if (ch.y < disItem.y) {
								container.addChildAt(disItem, top + 1);
							}
							else {
								container.addChildAt(disItem, top);
							}
							break;
						}
					}
				}
			}
		}
		
		/**
		 * 根据disItem.parent容器的所有子显示对象的Y值排列层深
		 * @param disItem
		 * disItem.parent != null
		 * 线性查找
		 */		
		public static function linearUpdateItemDepthByY(disItem:DisplayObject):void {
			var container:DisplayObjectContainer = disItem.parent;
			var chn:int = container.numChildren;
			if (chn < 2) {
				
			}
			else
			if (chn == 2) {
				var ch1:DisplayObject = container.getChildAt(0);
				var ch2:DisplayObject = container.getChildAt(1);
				if (ch1.y > ch2.y) {
					container.swapChildrenAt(0, 1);
				}
			}
			else {
				container.removeChild(disItem);
				--chn;
				for (var i:int = 0; i < chn; ++i) {
					if (disItem.y <= container.getChildAt(i).y) {
						container.addChildAt(disItem, i);
						return;
					}
				}
				container.addChild(disItem);
			}
		}
		
		/**
		 * 对容器中所有显示对象按照Y值排层深
		 * @param container
		 * 冒泡排序
		 */		
		public static function bubbleSortContainerDepthByY(container:DisplayObjectContainer):void {
			var top:int = container.numChildren - 1;
			for (var i:int = 0; i < top; ++i) {
				var bSwapped:Boolean = false;
				var ch1:DisplayObject = container.getChildAt(0);
				for (var j:int = 0; j < top - i; ++j) {
					var ch2:DisplayObject = container.getChildAt(j + 1);
					if (ch1.y > ch2.y) {
						container.swapChildrenAt(j, j + 1);
						bSwapped = true;
					}
					else {
						ch1 = ch2;
					}
				}
				if (!bSwapped) {
					break;
				}
			}
		}
		
		/**
		 * 对容器中所有显示对象按照Y值排层深
		 * @param container
		 * 鸡尾酒排序
		 */
		public static function cocktailSortContainerDepthByY(container:DisplayObjectContainer):void {
			var top:int = container.numChildren - 1;
			var bottom:int = 0;
			var bSwapped:Boolean = true;
			
			var i:int;
			var ch1:DisplayObject = null;
			var ch2:DisplayObject = null;
			while (bSwapped && top > bottom) {
				bSwapped = false;
				ch1 = container.getChildAt(bottom);
				for (i = bottom; i < top; ++i) {
					ch2 = container.getChildAt(i + 1);
					if (ch1.y > ch2.y) {
						container.swapChildrenAt(i, i + 1);
						bSwapped = true;
					}
					else {
						ch1 = ch2;
					}
				}
				--top;
				
				ch2 = container.getChildAt(top);
				for (i = top; i > bottom; --i) {
					ch1 = container.getChildAt(i - 1);
					if (ch1.y > ch2.y) {
						container.swapChildrenAt(i - 1, i);
						bSwapped = true;
					}
					else {
						ch2 = ch1;
					}
				}
				++bottom;
			}
		}
		
		/**
		 * 对容器中所有显示对象按照Y值排层深
		 * @param container
		 * 快速排序
		 * 这个绝对够快啊，推荐使用
		 */	
		public static function quickSortContainerDepthByY(container:DisplayObjectContainer):void {
			doQuickSortContainer(container, 0, container.numChildren - 1);
		}
		
		private static function doQuickSortContainer(container:DisplayObjectContainer, b:int, e:int):void {
			if (e > b) {
				var piv:int = b;
				var k:int = b + 1;
				var r:int = e;
				var pivCh:DisplayObject = container.getChildAt(piv);
				var ch:DisplayObject = null;
				while (k != r /*k < r*/) {
					ch = container.getChildAt(k);
					if (ch.y < pivCh.y) {
						++k;
					}
					else {
						container.swapChildrenAt(k, r--);
					}
				}
				ch = container.getChildAt(k);
				if (ch.y < pivCh.y) {
					container.swapChildrenAt(k, b);
					doQuickSortContainer(container, b, k - 1);
					doQuickSortContainer(container, r + 1, e);
				}
				else {
					if (e - b > 1) {
						--k;
						container.swapChildrenAt(k, b);
						doQuickSortContainer(container, b, k - 1);
						doQuickSortContainer(container, k + 1, e);
					}
				}
			}
		}
		
		/**
		 * 对容器中所有显示对象按照Y值+height/2排层深 适合注册点在中心，以mc底部y值排序的情况
		 * @param container
		 * 快速排序
		 * 这个绝对够快啊，推荐使用
		 */
		public static function quickSortContainerDepthByY2(container:DisplayObjectContainer):void {
			doQuickSortContainer2(container, 0, container.numChildren - 1);
		}
		
		private static function doQuickSortContainer2(container:DisplayObjectContainer, b:int, e:int):void {
			if (e > b) {
				var piv:int = b;
				var k:int = b + 1;
				var r:int = e;
				var pivCh:DisplayObject = container.getChildAt(piv);
				var ch:DisplayObject = null;
				while (k != r /*k < r*/) {
					ch = container.getChildAt(k);
					if (ch.y+ch.height/2 < pivCh.y+pivCh.height/2) {
						++k;
					}
					else {
						container.swapChildrenAt(k, r--);
					}
				}
				ch = container.getChildAt(k);
				if (ch.y+ch.height/2 < pivCh.y+pivCh.height/2) {
					container.swapChildrenAt(k, b);
					doQuickSortContainer2(container, b, k - 1);
					doQuickSortContainer2(container, r + 1, e);
				}
				else {
					if (e - b > 1) {
						--k;
						container.swapChildrenAt(k, b);
						doQuickSortContainer2(container, b, k - 1);
						doQuickSortContainer2(container, k + 1, e);
					}
				}
			}
		}
		
		/**
		 * 对容器中所有显示对象按照Y值排层深
		 * @param container
		 * 选择排序
		 */
		public static function selectSortContainerDepthByY(container:DisplayObjectContainer):void {
			var l:int = container.numChildren;
			for (var i:int = 1; i < l; ++i) {
				var iMin:int = i - 1;
				var minCh:DisplayObject = container.getChildAt(iMin);
				for (var j:int = i; j < l; ++j) {
					var ch:DisplayObject = container.getChildAt(j);
					if (minCh.y > ch.y) {
						iMin = j;
						minCh = ch;
					}
				}
				if (iMin != (i - 1)) {
					container.swapChildrenAt(iMin, i - 1);
				}
			}
		}
		
		/**
		 * 对容器中所有显示对象按照Y值排层深
		 * @param container
		 * 堆排序
		 */
		public static function heapSortContainerDepthByY(container:DisplayObjectContainer):void {
			for (var i:int = container.numChildren - 1; i > 0; --i) {
				heapTree(container, i, i);
			}
		}
		
		private static function heapTree(container:DisplayObjectContainer, iRootIndex:int, iTopIndex:int):void {
			if (iRootIndex > iTopIndex) {
				return;
			}
			
			var iLeftIndex:int = 0;
			var iRightIndex:int = 1;
			if (iRootIndex < iTopIndex) {
				iLeftIndex = (iRootIndex + 1) * 2;
				iRightIndex = iLeftIndex + 1;
			}
			
			if (iLeftIndex < iTopIndex) {
				var chRoot:DisplayObject = container.getChildAt(iRootIndex);
				var chLeft:DisplayObject = container.getChildAt(iLeftIndex);
				if (iRightIndex < iTopIndex) {
					var chRight:DisplayObject = container.getChildAt(iRightIndex);
					if (chLeft.y > chRight.y) {
						if (chLeft.y > chRoot.y) {
							container.swapChildrenAt(iLeftIndex, iRootIndex);
						}
					}
					else {
						if (chRight.y > chRoot.y) {
							container.swapChildrenAt(iRightIndex, iRootIndex);
						}
					}
					
					heapTree(container, iLeftIndex, iTopIndex);
					heapTree(container, iRightIndex, iTopIndex);
					
					chRoot = container.getChildAt(iRootIndex);
					chLeft = container.getChildAt(iLeftIndex);
					chRight = container.getChildAt(iRightIndex);
					if (chLeft.y > chRight.y) {
						if (chLeft.y > chRoot.y) {
							container.swapChildrenAt(iLeftIndex, iRootIndex);
						}
					}
					else {
						if (chRight.y > chRoot.y) {
							container.swapChildrenAt(iRightIndex, iRootIndex);
						}
					}
				}
				else {
					if (chLeft.y > chRoot.y) {
						container.swapChildrenAt(iLeftIndex, iRootIndex);
					}
				}
			}
			else {
				
			}
		}
		
		public static function bringToBottom(mc:DisplayObject):void{
			var parent:DisplayObjectContainer = mc.parent;
			if(parent == null){ return; }
			if(parent.getChildIndex(mc) != 0){
				parent.setChildIndex(mc, 0)
			}
		}
		
		/**
		 * Bring the mc to all brother mcs' top.
		 */	
		public static function bringToTop(mc:DisplayObject):void{
			var parent:DisplayObjectContainer = mc.parent;
			if(parent == null) return;
			parent.addChild(mc);
		}
		
	}
}

