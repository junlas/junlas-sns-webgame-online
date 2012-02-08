package junlas.util
{
	import flash.text.Font;
	import flash.utils.getDefinitionByName;

	public class Fonts
	{
		public static var DefaultFontName : String = "Arial";
        public static var DefaultFontSize : uint = 12;
        public static var DefaultIsEmbedded : Boolean = true;
		//MUST USE -managers flash.fonts.AFEFontManager in compiler directive
		public static function ensureFont(fontName:String):String{
			var fontClass:Class = getByName(fontName);
			if(fontClass){
				Font.registerFont( fontClass );
				return fontName;
			}
			return null;
		}
		
		private static function getByName(fontName:String):Class {
			/*var fontArr:Array = Font.enumerateFonts(true);
			for each (var font:Font in fontArr) {
				if(font.fontName == fontName)return getde;
			}
			*/
			return null;
		}
	}
}