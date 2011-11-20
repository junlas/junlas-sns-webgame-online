package junlas.components.piclist{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import junlas.utils.math.mVector;

	/**
	 *@author lvjun01
	 */
	public class JListItem{
		private var _pmc:Sprite;
		private var _car:JCar;
		private var _content:DisplayObject;
		
		public function JListItem(pmc:Sprite,content:DisplayObject) {
			_pmc = pmc;
			_content = content;
			_car = new JCar();
		}
		
		public function updatePos(pos:mVector,isTween:Boolean = true):void {
			_car.postion = pos.clone();
			if(isTween){
			
			}else{
				_content.x = _car.postion.x;
				_content.y = _car.postion.y;
				_pmc.addChild(_content);
			}
		}
	}
}