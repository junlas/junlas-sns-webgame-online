package junlas.loads
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * PicLoadUtil 图片加载工具
	 * @author 刘佳 liujia08@snda.com
	 * $Id: PicLoadUtil.as 4016 2011-09-29 03:23:54Z liujia $
	 * @version 1.0
	 */
	public class PicLoadUtil
	{
		/**
		 * 如果加载失败，最大的重试次数
		 */		
		public static var maxRetry:int = 2;
		
		/**
		 *加载url地址的图片，使用ct.addChild(loader.content)显示
		 * @param url 图片的URL
		 * @param ct 父容器
		 * @param autoCenter 是否自动将图片居中
		 * @param clearContainer 是否清空父容器
		 * 
		 */		
		public static function bindUrl2Ct(url:String, ct:DisplayObjectContainer, w:Number=-1, h:Number=-1, autoCenter:Boolean=true, clearContainer:Boolean=true, onComplete:Function=null):void {
			new PicLoadUtil().bindUrl2Ct(url, ct, w, h, autoCenter, clearContainer);
		}
		
		/**
		 *加载url地址的图片，使用ct.addChild(loader)显示，避免安全沙箱问题
		 * @param url 图片的URL
		 * @param ct 父容器
		 * @param autoCenter 是否自动将图片居中
		 * @param clearContainer 是否清空父容器
		 * 
		 */		
		public static function bindUrl2Ct2(url:String, ct:DisplayObjectContainer, w:Number=-1, h:Number=-1, autoCenter:Boolean=true, clearContainer:Boolean=true, onComplete:Function = null):void {
			new PicLoadUtil().bindUrl2Ct2(url, ct, w, h, autoCenter, clearContainer,onComplete);
		}
		
		
		
		private var retryTime:int = 0;
		private function bindUrl2Ct(url:String, ct:DisplayObjectContainer, w:Number, h:Number, autoCenter:Boolean, clearContainer:Boolean, onComplete:Function=null):void {
			if (url == null || ct == null) return;
			//如果要加载的图片和原来的一样，就不需要加载了
			var child:DisplayObject = ct.numChildren > 0 ? ct.getChildAt(0) : null;
			if (child && child.loaderInfo && (child.loaderInfo.loaderURL == url)) {
				return;
			}
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			try{
				loader.load(new URLRequest(url));
			}catch(e:*){
				trace("出错啦:"+url);
			}
			
			function errorHandler(e:Event):void {
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				loader.unloadAndStop();
				
				if (++retryTime <= maxRetry) {
					trace("[PicLoadUtil] 加载图片出错! url=" + url + " ,正在重新加载,第" + retryTime + "次..");
					bindUrl2Ct(url, ct, w, h, autoCenter, clearContainer);
				} else {
					trace("[PicLoadUtil] 加载图片出错! url=" + url + " ,停止重新加载");
				}
			}
			
			function completeHandler(e:Event):void {
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				//清空容器
				if (clearContainer) {
					while (ct.numChildren > 0) {
						ct.removeChildAt(0);
					}
				}
				var child:DisplayObject = loader.content;
				//强制宽高
				var scaleX:Number = 1;
				var scaleY:Number = 1;
				if (w > -1) {
					scaleX = w / child.width;
				}
				if (h > -1) {
					scaleY = h / child.height;
				}
				if (scaleX > scaleY) {
					child.scaleX = child.scaleY = scaleY;
				} else {
					child.scaleX = child.scaleY = scaleX;
				}
				
				ct.addChild(child);
				//居中
				if (autoCenter) {
					child.x = - child.width / 2;
					child.y = - child.height / 2;
				}
				loader.unloadAndStop();
				if(onComplete != null){
					onComplete(child);
				}
			}
		}
		
		private function bindUrl2Ct2(url:String, ct:DisplayObjectContainer, w:Number, h:Number, autoCenter:Boolean, clearContainer:Boolean, onComplete:Function=null):void {
			if (url == null || ct == null) return;
			//如果要加载的图片和原来的一样，就不需要加载了
			var child:Loader = ct.numChildren > 0 ? ct.getChildAt(0) as Loader : null;
			if (child && child.contentLoaderInfo.url == url) {
				return;
			}
			if (child && child.contentLoaderInfo.url != url) {
				while (ct.numChildren > 0) {
					ct.removeChildAt(0);
				}
			}
				
			var loader:Loader = new Loader();
			
			//清空容器
			if (clearContainer) {
				while (ct.numChildren > 0) {
					ct.removeChildAt(0);
				}
			}
			ct.addChild(loader);
			
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			try{
				loader.load(new URLRequest(url));
			}catch(e:*){
				trace("出错啦:"+url);
			}
			
			function errorHandler(e:Event):void {
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				loader.unloadAndStop();
				
				DisplayObjectUtil.removeDisplayObject(loader);
				
				if (++retryTime <= maxRetry) {
					trace("[PicLoadUtil] 加载图片出错! url=" + url + " ,正在重新加载,第" + retryTime + "次..");
					bindUrl2Ct2(url, ct, w, h, autoCenter, clearContainer);
				} else {
					trace("[PicLoadUtil] 加载图片出错! url=" + url + " ,停止重新加载");
				}
			}
			
			function completeHandler(e:Event):void {
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				
				var child:DisplayObject = loader;
				//强制宽高
				var scaleX:Number = 1;
				var scaleY:Number = 1;
				if (w > -1) {
					scaleX = w / child.width;
				}
				if (h > -1) {
					scaleY = h / child.height;
				}
				if (scaleX > scaleY) {
					child.scaleX = child.scaleY = scaleY;
				} else {
					child.scaleX = child.scaleY = scaleX;
				}
				
				//居中
				if (autoCenter) {
					child.x = - child.width / 2;
					child.y = - child.height / 2;
				}
				//loader.unload();
				if(onComplete != null){
					onComplete(child);
				}
			}
		}
		
	}
}
