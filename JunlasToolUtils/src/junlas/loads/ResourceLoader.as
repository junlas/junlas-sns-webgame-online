package junlas.loads
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Timer;
	
	/**
	 * 队列加载管理类
	 * @author 陆小龙 luxiaolong.lux@snda.com 
	 * $Id: ResourceLoader.as 2649 2011-08-11 05:21:39Z lvjun $
	 * @version $(DefaultVersion)
	 */
	public class ResourceLoader extends EventDispatcher
	{
		public static const HIGH_PRIORITY:int = 10000;		// 高优先级加载
		public static const MIDDLE_PRIORITY:int = 0;		// 中优先级
		public static const LOW_PRIORITY:int = -10000;		// 低优先级
		public static const TOTAL_THREAD_NUM:int = 3;		// 最高并发加载数
		
		private var _loaderList:Array;						// 加载器列表
		
		private var _isSort:Boolean;						// 排序标识,当队列中有新元素加入或者改变了队列中元素的加载优先级设为真
		private var _queueArr:Array;
		private var _highPriorityRecNum:int;
		private var _totalResNum:int;
		private var _total:int;
		
		public static const HIGH_SOURCE_COMPLETE:String = "high_source_complete";				// 所有高优属性资源加载完成
		public static const ALL_COMPLETE:String = "all_complete";								// 所有资源加载完成
		public static const ONE_RESOURCE_COMPLETE:String = "one_resource_complete";				// 有一个资源加载完成
		
		public static var isLoadingObj:Object = { };
		
		public function ResourceLoader(single:Single)
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
			init();
		}
		
		/**
		 * 初始化
		 */
		public function init():void
		{
			_queueArr = [];
			_highPriorityRecNum = 0;
			_totalResNum = 0;
			clearLoaderList();
			initLoaderList();
			_total = 0;
		}
		
		// 建立加载器列表
		private function initLoaderList():void
		{
			_loaderList = [];
			for (var i:int = 0; i < TOTAL_THREAD_NUM; i++) 
			{
				_loaderList[i] = new ThreadLoader();
			}
		}
		
		/**
		 * 以对象容器的X轴位置大小排序
		 */
		public function sortByPosX(index:int = 0):void
		{
			var len:int = _queueArr[i];
			for (var i:int = 0; i < len;i++ )
			{
				var obj:Object = _queueArr[i][0];
				var mc:MovieClip = obj.container as MovieClip;
				if(mc) obj.priority = 5000/index - mc.x >> 0;
			}
			//_isSort = true;
			_queueArr.sort(sortQueue);
		}
		
		/**
		 *  设置指定元素的加载优先级
		 * @param	className	-	类名
		 * @param	priority	- 优先值
		 */
		public function setPriority(className:String, priority:int):Boolean
		{
			var flag:Boolean = false;
			for each (var arr:* in _queueArr)
			{
				var obj:Object = arr[0];
				if (obj.className == className)
				{
					if (obj.priority == priority) return flag;
					
					if (priority == HIGH_PRIORITY ) 
					{
						_highPriorityRecNum ++;
					}
					obj.priority = priority;
					flag = true;
					break;
				}
			}
			if (flag)
			{
				//_isSort = true;		// 改变了队列中元素的优先级,排序标识设为真
				_queueArr.sort(sortQueue);
			}
			
			return flag;
		}
		
		public function queueSort():void
		{
			_queueArr.sort(sortQueue);
		}
		
		public function load(urlString:String, className:String, container:MovieClip = null,priority:int = -1, fun:Function = null,parameter:Object = null,sort:Boolean = false):void
		{
			if (urlString)
			{
				var obj:Object;
				if (isLoadingObj[className])						// 该资源已经开始加载,但还没加载完成,给个容器和函数给它该资源加载完成以后也告诉我一声
				{
					if (!container && fun == null) return;			// 不想知道?,我就不告诉你
					var len:int = _queueArr.length;
					
					for (var i:int = 0; i < len; i++) 
					{
						var arr:Array = _queueArr[i];
						obj = arr[0];
						if (obj.className == className)
						{
							// 添加到回调处理列表
							arr.push({url:urlString, className:className, fun:fun, parameter:parameter, priority:priority, container:container});
							return;
						}
					}
				}
				isLoadingObj[className] = true;
				
				// 资源信息饱含:地址,类名,函数,参数,优先级,容器
				obj = { url:urlString, className:className, fun:fun, parameter:parameter, priority:priority, container:container};
				_queueArr.push([obj]);
				if (priority == HIGH_PRIORITY) _highPriorityRecNum ++;
				_totalResNum ++;
				_total ++;
				_isSort = sort;
				start();
			}
		}
		
		/**
		 * load方法的山寨版
		 * 添加要加载的资源地址等信息
		 * 但要调用start方法后才开始下载.
		 * 
		 * @param	urlString		- 资源地址
		 * @param	className		- 加载完成后需要自动添加到容器和回调函数第一个参数的显示对象类名
		 * @param	container		- 加载完成后该显示对象会自动添加到这个容器里面
		 * @param	priority		- 加载优先级
		 * @param	fun				- 回调函数
		 * @param	parameter		- 回调函数的第二个参数
		 * @param	sort			- 是否对资源队列排序
		 */
		public function add(urlString:String, className:String, container:MovieClip = null,priority:int = -1, fun:Function = null,parameter:Object = null,sort:Boolean = false):void
		{
			if (urlString)
			{
				var obj:Object;
				if (isLoadingObj[className])						// 该资源已经开始加载,但还没加载完成,给个容器和函数给它该资源加载完成以后也告诉我一声
				{
					if (!container && fun == null) return;			// 不想知道我就不告诉你
					var len:int = _queueArr.length;
					
					for (var i:int = 0; i < len; i++) 
					{
						var arr:Array = _queueArr[i];
						obj = arr[0];
						if (obj.className == className)
						{
							// 添加到回调处理列表
							arr.push({url:urlString, className:className, fun:fun, parameter:parameter, priority:priority, container:container});
							return;
						}
					}
				}
				isLoadingObj[className] = true;
				
				// 资源信息饱含:地址,类名,函数,参数,优先级,容器
				obj = { url:urlString, className:className, fun:fun, parameter:parameter, priority:priority, container:container};
				_queueArr.push([obj]);
				if (priority == HIGH_PRIORITY) _highPriorityRecNum ++;
				_totalResNum ++;
				_total ++;
				_isSort = sort;
			}
		}
		
		// 对资源优先级排序
		private function sortQueue(a:Object,b:Object):Number
		{
			var aNum:Number = a[0]["priority"];
			var bNum:Number = b[0]["priority"];
			if (aNum > bNum)
			{
				return -1;
			}
			else if(aNum < bNum)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 启动队列加载
		 */
		public function start(e:Event = null):void
		{	
			if (_queueArr.length <=  0) return;
			
			if (_loaderList.length <= 0)	return;												//  有空闲加载器时执行操作
			
			if (_isEnforce) startForceTimer();
			
			if (_isSort)
			{
				_queueArr.sort(sortQueue);
				_isSort = false;
			}
			var arr:Array = _queueArr.shift();
			
			var loader:ThreadLoader = _loaderList.pop() as ThreadLoader;
			loader.add(arr);
			loader.start();
			loader.addEventListener(Event.COMPLETE, loadedHdr);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);	
		}
		
		// 跟踪高优先级资源的加载情况
		private function reduceHighResNum(priority:int):void
		{
			if (priority == HIGH_PRIORITY) 			
			{
				if (_highPriorityRecNum > 0)
				{
					_highPriorityRecNum--;
				}
				
				if (_highPriorityRecNum == 0)
				{	
					dispatchEvent(new Event(HIGH_SOURCE_COMPLETE));
				}
				
			}
		}
		
		private function reduceTotalResNum():void
		{
			if (_totalResNum > 0)
			{
				_totalResNum--;
			}
			
			if (_totalResNum == 0)
			{	
				_total = 0;
				//dispatchEvent(new Event(HIGH_SOURCE_COMPLETE));
				//dispatchEvent(new Event(ALL_COMPLETE));
				allCompleteNotify();
			}
		}
		
		private var _forceTimer:Timer = new Timer(1000);
		private var _oldProgress:Number = 0;
		private var _timerOut:int = 0;
		private var _isEnforce:Boolean = false;
		
		public function set enforce(values:Boolean):void
		{
			_isEnforce = values;
		}
		
		
		private function startForceTimer():void
		{
			_forceTimer.addEventListener(TimerEvent.TIMER, forceTimerHdr);
			_forceTimer.start();
		}
		
		private function stopForceTimer():void
		{
			if(_forceTimer.running) _forceTimer.reset();
			if (_forceTimer.hasEventListener(TimerEvent.TIMER)) 
				_forceTimer.removeEventListener(TimerEvent.TIMER, forceTimerHdr);
		}
		
		private function forceTimerHdr(e:TimerEvent):void 
		{
			if (_oldProgress != currentProgress)
			{
				_oldProgress = currentProgress;
				_timerOut = 0;
			}
			else
			{
				_timerOut ++;
				if (_timerOut > 3)
				{
					allCompleteNotify();
				}
			}
		}
		
		public function allCompleteNotify():void
		{
			if(_isEnforce) stopForceTimer();
			dispatchEvent(new Event(HIGH_SOURCE_COMPLETE));
			dispatchEvent(new Event(ALL_COMPLETE));
		}
		
		private function clearLoaderList():void
		{
			for each(var loader:ThreadLoader in _loaderList) 
			{
				loader.destroy();
				if(loader.hasEventListener(Event.COMPLETE)) loader.removeEventListener(Event.COMPLETE, loadedHdr);
				if(loader.hasEventListener(IOErrorEvent.IO_ERROR)) loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			}
		}
		
		// 析构
		public function destroy():void
		{
			clearQueue();			// 清空资源队列
			clearLoaderList();		
			_instance = null;
		}
		
		// 加载超时
		private function onError(e:IOErrorEvent):void 
		{
			var loader:ThreadLoader = e.currentTarget as ThreadLoader;
			loader.removeEventListener(Event.COMPLETE, loadedHdr);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);	
			reduceHighResNum(loader.priority);
			reduceTotalResNum();
			_loaderList.unshift(loader);												// 归还加载器
			dispatchEvent(new Event(ONE_RESOURCE_COMPLETE) );
			start();
		}
		
		// 完成一个文件加载
		private function loadedHdr(e:Event):void 
		{
			var loader:ThreadLoader = e.currentTarget as ThreadLoader;
			loader.removeEventListener(Event.COMPLETE, loadedHdr);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);	
			reduceHighResNum(loader.priority);
			reduceTotalResNum();
			_loaderList.unshift(loader);												//归还加载器
			dispatchEvent(new Event(ONE_RESOURCE_COMPLETE) );
			start();
		}
		
		// 清空队列
		public function clearQueue():void
		{
			_queueArr.length = 0;
		}
		
		//------------------------------------------------------
		/**
		 *  获取单例
		 */
		public static function get instance():ResourceLoader
		{
			if(_instance == null)
			{
				_instance = new ResourceLoader(new Single());
			}
			return _instance;
		}
		
		// 获取资源队列当前状态
		public function get isQueueEnpty():Boolean 
		{
			return _queueArr.length == 0;
		}
		// 加载队列资源是否全部完成
		public function get isAllComplete():Boolean 
		{
			return _totalResNum == 0;
		}
		
		public function get isHighLoaded():Boolean 
		{
			return _highPriorityRecNum == 0;
		}
		
		public function get highPriorityRecNum():int { return _highPriorityRecNum; }
		
		public function get isSort():Boolean { return _isSort; }
		
		// 加载完成比例
		public function get currentProgress():Number
		{
			return _totalResNum/_total;
		}
		
		public function isRunning():Boolean
		{
			return _loaderList.length < TOTAL_THREAD_NUM;
		}
		
		public function get totalResNum():int { return _totalResNum; }
		
		public function set totalResNum(value:int):void 
		{
			_totalResNum = value;
		}
		
		public function get total():int { return _total; }
		
		public function set total(value:int):void 
		{
			_total = value;
		}
		
		public function set isSort(value:Boolean):void 
		{
			_isSort = value;
		}
		
		public function get queueArr():Array { return _queueArr; }
		
		private static var _instance:ResourceLoader = null;
		
	}
}
class Single{}