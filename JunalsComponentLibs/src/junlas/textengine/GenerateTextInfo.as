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
		
		/**
		 * 销毁
		 */
		public function destroy():void{
			while(_generateTextContainer.numChildren){
				_generateTextContainer.removeChildAt(0);
			}
			if(_generateTextContainer.parent){
				_generateTextContainer.parent.removeChild(_generateTextContainer);
			}
		}
	}
}