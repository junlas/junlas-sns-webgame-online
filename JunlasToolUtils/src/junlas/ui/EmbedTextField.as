package junlas.ui
{
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.GridFitType;
	
	public class EmbedTextField extends TextField
	{
		public function EmbedTextField()
		{
			//TODO: implement function
			super();
			embedFonts = true;
			gridFitType = GridFitType.SUBPIXEL;
			antiAliasType = AntiAliasType.ADVANCED;
		}
		
	}
}