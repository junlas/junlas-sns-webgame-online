package junlas.components.scrollpanel
{

	public class JStyle
	{
		public static var TEXT_BACKGROUND:uint = 0xFFFFFF;
		public static var BACKGROUND:uint = 0xCCCCCC;
		public static var BUTTON_FACE:uint = 0xFFFFFF;
		public static var BUTTON_DOWN:uint = 0xEEEEEE;
		public static var INPUT_TEXT:uint = 0x333333;
		public static var LABEL_TEXT:uint = 0x666666;
		public static var DROPSHADOW:uint = 0x000000;
		public static var PANEL:uint = 0xF3F3F3;
		public static var PROGRESS_BAR:uint = 0xFFFFFF;
		public static var LIST_DEFAULT:uint = 0xFFFFFF;
		public static var LIST_ALTERNATE:uint = 0xF3F3F3;
		public static var LIST_SELECTED:uint = 0xCCCCCC;
		public static var LIST_ROLLOVER:uint = 0XDDDDDD;
		
		public static var embedFonts:Boolean = false;
		public static var fontName:String = "黑体";
		public static var fontSize:Number = 12;
		
		public static const DARK:String = "dark";
		public static const LIGHT:String = "light";
		
		/**
		 * Applies a preset style as a list of color values. Should be called before creating any components.
		 */
		public static function setStyle(style:String):void
		{
			switch(style)
			{
				case DARK:
					JStyle.BACKGROUND = 0x444444;
					JStyle.BUTTON_FACE = 0x666666;
					JStyle.BUTTON_DOWN = 0x222222;
					JStyle.INPUT_TEXT = 0xBBBBBB;
					JStyle.LABEL_TEXT = 0xCCCCCC;
					JStyle.PANEL = 0x666666;
					JStyle.PROGRESS_BAR = 0x666666;
					JStyle.TEXT_BACKGROUND = 0x555555;
					JStyle.LIST_DEFAULT = 0x444444;
					JStyle.LIST_ALTERNATE = 0x393939;
					JStyle.LIST_SELECTED = 0x666666;
					JStyle.LIST_ROLLOVER = 0x777777;
					break;
				case LIGHT:
				default:
					JStyle.BACKGROUND = 0xCCCCCC;
					JStyle.BUTTON_FACE = 0xFFFFFF;
					JStyle.BUTTON_DOWN = 0xEEEEEE;
					JStyle.INPUT_TEXT = 0x333333;
					JStyle.LABEL_TEXT = 0x666666;
					JStyle.PANEL = 0xF3F3F3;
					JStyle.PROGRESS_BAR = 0xFFFFFF;
					JStyle.TEXT_BACKGROUND = 0xFFFFFF;
					JStyle.LIST_DEFAULT = 0xFFFFFF;
					JStyle.LIST_ALTERNATE = 0xF3F3F3;
					JStyle.LIST_SELECTED = 0xCCCCCC;
					JStyle.LIST_ROLLOVER = 0xDDDDDD;
					break;
			}
		}
	}
}