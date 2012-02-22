package junlas.components.scrollpanel{
	import junlas.components.base.JVisiualConfig;

	/**
	 *@desc:滚动条组件的整个各组成名称
	 *@author lvjun01
	 */
	public class JVisiualScrollPanelConf extends JVisiualConfig{
		/**
		 * 滚动条组件背景名称
		 */
		public var panel_background:String = "scroll_background";
		/**
		 * 滚动条组件向上按钮名称
		 */
		public var slider_btn_up:String = "slider_up";
		/**
		 * 按钮的宽
		 */
		public var button_up_left_width:int = 40;
		/**
		 * 按钮的高
		 */
		public var button_up_left_height:int = 40;
		/**
		 * 按钮的宽
		 */
		public var button_down_right_width:int = 40;
		/**
		 * 按钮的高
		 */
		public var button_down_right_height:int = 40;
		/**
		 * 滚动条组件向下按钮名称
		 */
		public var slider_btn_down:String = "slider_down";
		/**
		 * 滚动条组件滑动块背景名称
		 */
		public var slider_back:String = "slider_back";
		/**
		 * 滚动条组件滑动块名称
		 */
		public var slider_btn_handler:String = "slider_handler";
		
		/**
		 * 滚动条组件向左按钮(底部)名称
		 */
		public var slider_btn_left:String = "slider_left";
		/**
		 * 滚动条组件向右按钮(底部)名称
		 */
		public var slider_btn_right:String = "slider_right";
		/**
		 * 滚动条组件滑动块背景(底部)名称
		 */
		public var slider_bottom_back:String = "slider_bottom_back";
		/**
		 * 滚动条组件滑动块(底部)名称
		 */
		public var slider_bottom_btn_handler:String = "slider_bottom_handler";
		/**
		 * 内容面板最大显示的条目数,超过这个条目数，则删除上面多余的部分
		 */
		public var number_panel_content_item:int = int.MAX_VALUE;
		
		public var button_up_left_visible:Boolean = true;
		
		public var button_down_right_visible:Boolean = true;
		
		public var slider_btn_handler_visible:Boolean = true;
		
		public var slider_botton_btn_handler_visible:Boolean = true;
		
		public var slider_back_visible:Boolean = true;
		
		public var slider_botton_back_visible:Boolean = true;
		
	}
}