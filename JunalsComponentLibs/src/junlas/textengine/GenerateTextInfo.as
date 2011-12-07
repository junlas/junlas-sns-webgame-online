package junlas.textengine{
	import flash.display.Sprite;

	/**
	 *@author lvjun01
	 */
	public class GenerateTextInfo{
		private var _generateTextContainer:Sprite;
		
		public function GenerateTextInfo() {
			_generateTextContainer = new Sprite();
			//关闭鼠标
			_generateTextContainer.mouseChildren = _generateTextContainer.mouseEnabled = false;
		}
		
		public function getGenerateTextContainer():Sprite{
			return _generateTextContainer;
		}
	}
}