package junlas.loads
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.Timer;

	/**
	 * 队列加载
	 * @author 陆小龙 luxiaolong.lux@snda.com 
	 * $Id: ThreadLoader.as 4263 2011-10-18 01:38:50Z lvjun01 $
	 * @version $(DefaultVersion)
	 */
	public class ThreadLoader extends EventDispatcher
	{
		public static var TIME_OUT_LENGTH:int = 5000;		// 加载超时时长,这个时间不是加载时间,等待请求返回时间
		public static var MAX_ERROR_COUNT:int = 2;			// 加载出错指定次数后丢弃
		
		private	var _url:String ;							// 资源地址
		private	var _container:MovieClip;					// 容器
		private	var _className:String ;						// 资源导出类名
		private	var _fun:Function;							// 加载完成回调函数
		private	var _loader:Loader;							// 资源加载器
		private var _timer:Timer;							// 加载超时计时器
		private var _resourceInfo:Array;					// 资源详细信息
		private var _parameter:Object;						// 回调函数参数
		private var _priority:int;							// 优先级
		private var _urlRequest:URLRequest;					// 资源地址
		private var _isLoaded:Boolean;						// 标识当前资源是否已加载完毕
		private var _isDispatch:Boolean;					// 标识出错事件是否已发送
		private var _isTimerStart:Boolean;					// 标识计时器是否已启动
		private var _currentErrorCount:int;					// 出错连接出错计数
	
		public function ThreadLoader()
		{
			init();
		}
		
		public function init():void
		{
			_timer = new Timer(TIME_OUT_LENGTH,0);
			_loader = new Loader();
			_urlRequest = new URLRequest();
			_isLoaded = false;
			_isDispatch = false;
			_isTimerStart = false;
			_currentErrorCount = 0;
		}
		
		/**
		 * 开始加载
		 */
		public function start():void
		{
			if (!_isLoaded)
			{
				if (_url)
				{
					try
					{
						Security.allowDomain("*");
					}
					catch (error:SecurityError)
					{
					}
					var context:LoaderContext = new LoaderContext();
					if (Security.sandboxType == Security.REMOTE)
					{
						context.securityDomain = SecurityDomain.currentDomain;
					}
					context.applicationDomain = ApplicationDomain.currentDomain;				// 所有加载进来的资源与主程序同一程序域
					context.checkPolicyFile = true;
					try
					{
						_loader.load(_urlRequest, context);
					}
					catch (error:Error)
					{
						notifyError();
					}
					
					startTimer();
					addListener();
				}
			}
		}
		
		/**
		 * 添加将要加载的资源信息
		 * @param	resourceInfo	- 资源信息
		 */
		//public function add(resourceInfo:Object = null):void
		public function add(resourceInfo:Array):void
		{
			if (resourceInfo)
			{				
				_resourceInfo = resourceInfo;
				_url = resourceInfo[0].url;
				_container = resourceInfo[0].container;
				_className = resourceInfo[0].className;
				_fun = resourceInfo[0].fun;
				_parameter = resourceInfo[0].parameter;
				_priority = resourceInfo[0].priority;
				
				_urlRequest.url = _url;
				_isLoaded = false;
				_isDispatch = false;
				_isTimerStart = false;
			}
			else
			{
				_resourceInfo = null;
				_url = null;
				_container = null;
				_className = null;
				_fun = null;
				_parameter = null;
				_priority = 0;
			}
		}
		
		
		// 进度
		private function progressHdr(e:Event):void 
		{
			if(_isTimerStart) stopTimer();
		}
		
		 // 获取 HTTP 状态代码时触发, 通过判断他的 state 属性我们可以获得远程文件的加载状态. 
		 // 成功 (200), 没有权限 (403), 找不到文件 (404), 服务器内部错误 (500) 等等. 
		 // 这个事件总是在 compelete 之前被触发.
		private function httpStatusHdr(e:HTTPStatusEvent):void 
		{
			if (e.status > 0 && e.status != 200) 
            {
               notifyError();
            }
		}
		// 连接成功
		private function openHdr(e:Event):void 
		{
			if(_isTimerStart) stopTimer();
		}
		// 开始计时
		private function startTimer():void
		{
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, timeHdr); 
			_isTimerStart = true;
		}
		// 停止计时
		private function stopTimer():void
		{
			_timer.stop();
			if (_timer.hasEventListener(TimerEvent.TIMER)) _timer.removeEventListener(TimerEvent.TIMER, timeHdr);
			_isTimerStart = false;
		}
		// 发送出错事件
		private function notifyError(errorText:*=null):void
		{
			if (!_isDispatch)
			{
				for each(var obj:* in _resourceInfo)
				{
					var fun:Function = obj.fun as Function;
					
					if (fun != null)
					{
						trace(errorText,_url);
						fun(null, obj.parameter);
					}
				}
				clear();
				_isLoaded = true;
				_isDispatch = true;
				_currentErrorCount = 0;
				//dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,_url));	
				//trace("io error! url:",_url);
			}	
		}
		// 安全域
		private function securityErrorHdr(e:SecurityErrorEvent):void 
		{
			//trace("securityError!");
			timeHdr();
		}
		
		// 加载出错
		private function ioErrorHdr(e:IOErrorEvent):void 
		{
			notifyError(e.text);
		}
		// 加载超时
		private function timeHdr(e:TimerEvent = null):void 
		{
			//trace(this,"timerHdr url:",_url);
			stopTimer();
			if (_currentErrorCount ++ <  MAX_ERROR_COUNT)	
			{
				start();
			}
			else// 超时指定次数放弃重连,执行回调
			{
				notifyError();
			}
		}
		// 加载完成
		private function loadedHdr(e:Event):void 
		{
			var tempClass:Class;
			var flag:Boolean = _loader.contentLoaderInfo.applicationDomain.hasDefinition(_className);
			if (flag) 
			{
				tempClass = _loader.contentLoaderInfo.applicationDomain.getDefinition(_className)  as  Class;
			}
			// 
			for each(var obj:* in _resourceInfo)
			{
				var container:MovieClip = obj.container as MovieClip;
				var fun:Function = obj.fun as Function;
				
				if (container || fun != null)
				{
					if (tempClass) 
					{
						var mc:MovieClip = new tempClass() as MovieClip;
					}
					if (container) 
					{
						if(mc)	container.addChild(mc);
					}
					if (fun != null)
					{
						//try
						//{
							fun(mc, obj.parameter);
						//}
						//catch (e:Error)
						//{
							//throw new Error(e);
						//}
					}
				}
			}
			
			_isLoaded = true;
			
			_currentErrorCount = 0;
			// 好像时间安排太紧flashplayer会处理不过来哦,偷懒可以错开事件的冲突,不至以消息丢失,有益健康
			new CallBackTimer(20+Math.random() * 128 >> 0,dispathEvent);		
			_isDispatch = true;

			clear();
			
		}
		
		private function dispathEvent():void
		{
				dispatchEvent(new Event(Event.COMPLETE))
		}
		
		private function addListener():void
		{
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedHdr);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHdr);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHdr);
			
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHdr);
            _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHdr);
            _loader.contentLoaderInfo.addEventListener(Event.OPEN, openHdr);
		}
		
		private function removeListener():void
		{
			if (_loader.contentLoaderInfo.hasEventListener(Event.COMPLETE)) 
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedHdr);
			if (_loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR)) 
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHdr);
			if (_loader.contentLoaderInfo.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) 
				_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHdr);
			
			if (_loader.contentLoaderInfo.hasEventListener(HTTPStatusEvent.HTTP_STATUS)) 
				_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHdr);
            if (_loader.contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS)) 
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHdr);
            if (_loader.contentLoaderInfo.hasEventListener(Event.OPEN)) 
				_loader.contentLoaderInfo.removeEventListener(Event.OPEN, openHdr);
		}
		
		private function clear():void
		{
			removeListener();
			stopTimer();
			try
			{
				loader.close();
			}
			catch (error:Error)
			{
			}
			
			try
			{
				loader.unloadAndStop();
			}
			catch (error:Error)
			{
			}
			
		}
		/**
		 * 析构
		 */
		public function destroy():void
		{
			clear();
		}
		
		public function get loader():Loader { return _loader; }

		public function get isLoaded():Boolean { return _isLoaded; }
		
		public function get className():String { return _className; }
		
		public function get parameter():Object { return _parameter; }
		
		public function set parameter(value:Object):void 
		{
			_parameter = value;
		}
		
		public function get priority():int { return _priority; }
		
		public function set priority(value:int):void 
		{
			_priority = value;
		}
		
	}

}