package junlas.notifier {
	import flash.utils.Dictionary;

	/**
	 * @author lvjun01
	 */
	public class MsgNotifier {
		private static var _instance : MsgNotifier;
		private var _commandDict : Dictionary;
		public var IsDebugOpen:Boolean = true;
		private var _debug:Boolean;
		
		public function MsgNotifier(s:Single) {
			_commandDict = new Dictionary();
		}
		
		public static function getInstance(debug:Boolean = false) : MsgNotifier {
			if(!_instance){
				_instance = new MsgNotifier(new Single());
			}
			_instance._debug = debug;
			return _instance;
		}
		
		/**
		 * 注册命令
		 */
		public function registerCommand(commandName:String,handler:Function):void{
			_commandDict[commandName] = handler;
		}
		
		/**
		 * 检查是否存在此命令
		 */
		public function hasCommand(commandName:String):Boolean {
			return _commandDict[commandName] != null;
		}
		
		/**
		 * 获取此commandName对应的handler
		 */
		public function getCommandHandler(commandName:String):Function{
			return _commandDict[commandName];
		}
		
		/**
		 * 删除命令
		 * @param commandName 命令名,若未提供handler,则只删除commandName对应下的条目
		 * @param handler 若提供此参数,则必须commandName、handler同时对应注册时的值，才能删除
		 */
		public function removeCommand(commandName:String,handler:Function = null):void{
			if(!handler){
				_commandDict[commandName] = null;
				delete _commandDict[commandName];
			}else{
				var val:Function = _commandDict[commandName];
				if(val == handler){
					_commandDict[commandName] = null;
					delete _commandDict[commandName];
				}
			}
		}
		
		/**
		 * 发送命令
		 */
		public function sendCommamd(commandName:String,...argus):void{
			var handler:Function = _commandDict[commandName] as Function;
			if(handler){
				handler.apply(null,argus);
			}else{
				if(IsDebugOpen && _debug){
					trace("[[-->MsgNotifier:sendCommamd<--]发送commandName:"+commandName+",木有找到'handler']");
				}
			}
			
		}
		
		/**
		 * 重置，删除所有的command
		 */
		public function reset() : void {
			_commandDict = new Dictionary();
		}
	}
}


class Single{}