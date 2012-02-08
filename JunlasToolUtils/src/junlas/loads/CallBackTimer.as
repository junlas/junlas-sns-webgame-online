package junlas.loads
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 回调计时器
	 * @author cwin5
	 */
	public class CallBackTimer 
	{
		
		private var _timer:Timer = null;					// 计时器
		private var _callBack:Function = null;				// 回调
		private var _arg:Array = null;						// 回调参数数组
		
		/**
		 * 构造
		 * @param	delay		间隔,以毫秒为单位
		 * @param	callBack	回调
		 * @param	arg			回调参数
		 */
		public function CallBackTimer(delay:Number , callBack:Function , ...arg) 
		{
			_arg = arg;
			_callBack = callBack;
			_timer = new Timer ( delay );
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		/**
		 * 移除
		 */
		public function remove():void
		{
			onTimer(null);
		}
		
		/**
		 * 重置
		 */
		public function reset():void
		{
			_timer.reset();
		}
		
		// 计数完成
		private function onTimer(e:TimerEvent):void 
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer.reset();
			_timer = null;
			if (e)
			{
				_callBack.apply(null , _arg);
			}
		}
	}
	
}