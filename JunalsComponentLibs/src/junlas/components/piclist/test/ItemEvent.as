package junlas.components.piclist.test
{
	import flash.events.Event;

	/**
	 * @author breath xue
	 * ITEM事件邮包
	 */
	public class ItemEvent extends Event 
	{
		/**
		 * ITEM被点击时触发
		 */
		public static const CLICK_ITEM : String = "click_item";
		/**
		 * ITEM被建立时触发
		 */
		public static const ITEM_CREATE : String = "item_create";
		/**
		 * ITEM被删除时触发
		 */
		public static const ITEM_DELETE : String = "item_delete";
		/**
		 * ITEM被鼠标略过时触发
		 */
		public static const ITEM_ROLL_OVER : String = "item_roll_over";
		/**
		 * ITEM被鼠标略出时触发
		 */
		public static const ITEM_ROLL_OUT : String = "item_roll_out";
		private var _item : Item;

		public function ItemEvent(type : String,item : Item)
		{
			super(type);
			_item = item;
		}

		/**
		 * 获得ITEM对象.
		 */
		public function get item() : Item
		{
			return _item;
		}
	}
}
