package junlas.tooltip
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	public class ToolTipEvent extends Event
	{
		public var obj:*;
		public var noIcon:Boolean = false;
		
        public static const TOOLTIP_CHANGED : String = "__ttc";
        public static const CHANGE : String = "__ttch";
        
        public static var dispatcher:EventDispatcher = new EventDispatcher;
        
		public function ToolTipEvent(type:String, obj:* = null, noIcon:Boolean = false, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.obj = obj;
			this.noIcon = noIcon;
			super(type, bubbles, cancelable);
		}
		
	}
}