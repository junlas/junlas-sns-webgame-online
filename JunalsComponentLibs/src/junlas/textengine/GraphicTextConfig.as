package junlas.textengine{
	/**
	 *@author lvjun01
	 */
	public class GraphicTextConfig{
		/**
		 * 初始坐标x
		 */
		public var engine_x:Number = 0;
		/**
		 * 初始坐标y
		 */
		public var engine_y:Number = 0;
		/**
		 * TextBlock文本块的宽度
		 */
		public var engine_width:Number = 64;
		/**
		 * 行间距
		 */
		public var engine_line_spacing:Number = 20;
		/**
		 * 文本块排版显示旋转，仅仅支持：0、90、180、270，默认值0横排显示，除以上四种以外其它旋转值皆不做考虑<br/>
		 */
		public var engine_rotation:String = "0";
		
	}
}