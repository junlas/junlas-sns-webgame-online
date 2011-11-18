package junlas.components.piclist{
	import flash.display.DisplayObject;

	/**
	 *@author lvjun01
	 */
	public class JPiclistItem{
		private var _car:JCar;
		private var _content:DisplayObject;
		
		public function JPiclistItem(content:DisplayObject) {
			_content = content;
			_car = new JCar();
		}
	}
}