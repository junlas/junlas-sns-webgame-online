package junlas.timer{
	import flash.utils.getTimer;

	/**
	 *@author lvjun01
	 */
	public class JCallBackTimer{
		private static var _instance:JCallBackTimer;
		private var _items:Vector.<CallBackTimerItem> = new Vector.<CallBackTimerItem>();
		
		public function JCallBackTimer(s:Single) {
		}
		
		public static function get instance():JCallBackTimer{
			if(!_instance){
				_instance = new JCallBackTimer(new Single());
			}
			return _instance;
		}
		
		public function run():void {
			for(var i:int = _items.length-1;i>=0;i--) {
				var item :CallBackTimerItem = _items[i];
				if(item.run()) _items.splice(i,1)[0].destroy();
			}
			
		}
		
		public function register(delay:Number,callBackFunc:Function,...params):void{
			if(delay<=0){
				callBackFunc.apply(null,params);
			}else{
				_items.push(new CallBackTimerItem(delay,callBackFunc,params));
			}
		}
		
	}
}
import flash.utils.getTimer;

class CallBackTimerItem{
	public var delay:Number = 0;
	public var callBackFunc:Function;
	public var params:Array;
	///
	private var _futureTime:Number = 0;
	private var _nowTime:Number = 0;
	
	public function CallBackTimerItem(delay:Number,callBackFunc:Function,params:Array){
		this.delay = delay;
		this.callBackFunc = callBackFunc;
		this.params = params;
		_futureTime = getTimer() + delay;
	}
	public function run():Boolean {
		_nowTime = getTimer();
		if(_nowTime >= _futureTime){
			callBackFunc.apply(null,this.params);
			//this.callBackFunc();
			return true;
		} else
			return false;
	}
	
	public function destroy():void{
		delay = 0;
		callBackFunc = null;
	}
}

class Single{}